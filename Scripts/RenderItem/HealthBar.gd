class_name HealthBar extends RenderItem

@export var position_offset : Vector2

@export var width : float = 100
@export var height : float = 5
var rect_size : Vector2
var _old_percentage : float = 0
var percentage : float = 1
var drawing : bool = false
var parent_node : Node2D
var z_index : int = 10

var current_health : Stat
var max_health : Stat

var health_manager : HealthManager

func initialize(health_manager : HealthManager, parent_node : Node2D):
	create_canvas_item()
	rect_size = Vector2(width, height)
	drawing = true
	self.parent_node = parent_node
	RenderingServer.canvas_item_set_parent(canvas_item, parent_node.get_canvas())
	RenderingServer.canvas_item_set_z_index(canvas_item, z_index)
	
	
	self.health_manager = health_manager
	current_health = health_manager.current_health
	max_health = health_manager.max_health
	health_manager.current_health.value_changed.connect(_on_current_health_changed)
	health_manager.max_health.value_changed.connect(_on_max_health_changed)
	health_manager.health_depleted.connect(_on_health_depleted)
	
	percentage = current_health.get_value() / max_health.get_value()
	_old_percentage = percentage
	
	#adraw_bar()
	pass

func _process(delta: float) -> void:
	if !drawing:
		return
		
	var xForm : Transform2D = Transform2D(0, parent_node.global_position + position_offset)
	RenderingServer.canvas_item_set_transform(canvas_item, xForm)


func update_render():
	
	
	pass

func draw_bar():
	RenderingServer.canvas_item_clear(canvas_item)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, rect_size), Color.BLACK, true)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, Vector2(rect_size.x * percentage, rect_size.y)), Color.ORANGE_RED, true)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, Vector2(rect_size.x * percentage, rect_size.y)), Color.SEA_GREEN, true)
	pass

func _exit_tree() -> void:
	RenderingServer.canvas_item_clear(canvas_item)
	RenderingServer.free_rid(canvas_item)

func _on_current_health_changed(current_health : Stat, context : Dictionary[StringName, Variant]):
	drawing = true
	tweened_update()
	pass

func tweened_update():
	var tween : Tween = create_tween()
	percentage = clampf(current_health.get_value() / max_health.get_value(), 0, 1)
	tween.tween_method(tween_drain_bar, _old_percentage, percentage, 0.3)
	_old_percentage = percentage
	pass

func tween_drain_bar(value : float):
	RenderingServer.canvas_item_clear(canvas_item)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, rect_size), Color.BLACK, true)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, Vector2(rect_size.x * value, rect_size.y)), Color.ORANGE_RED, true)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, Vector2(rect_size.x * percentage, rect_size.y)), Color.SEA_GREEN, true)
	
	await get_tree().create_timer(5).timeout
	RenderingServer.canvas_item_clear(canvas_item)
	drawing = false
	pass

func _on_health_depleted():
	percentage = 0
	health_manager.current_health.value_changed.disconnect(_on_current_health_changed)
	health_manager.max_health.value_changed.disconnect(_on_max_health_changed)
	RenderingServer.canvas_item_clear(canvas_item)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, rect_size), Color.BLACK, true)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, Vector2(rect_size.x * 0, rect_size.y)), Color.ORANGE_RED, true)
	
	RenderingServer.canvas_item_add_rect(canvas_item, Rect2(global_position, Vector2(rect_size.x * 0, rect_size.y)), Color.SEA_GREEN, true)
	drawing = false
	pass

func _on_max_health_changed(max_health : Stat, context : Dictionary[StringName, Variant]):
	
	pass
