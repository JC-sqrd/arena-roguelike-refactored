class_name Arena extends Node2D

@export var main_tilemap_layer : TileMapLayer
@export var target_tilemap_layer : TileMapLayer
@export var spawn_tilemap_layer : TileMapLayer
@export var arena_ui : ArenaUI
@export var player_scene : PackedScene
@export var target_health_stat_template : StatTemplate
@export var targets : Array[EnemyTarget]

var max_target_health : Stat
var target_health_stat : Stat

func _ready():
	ArenaServer.active_arena = self
	var tile_size : Vector2i = main_tilemap_layer.tile_set.tile_size
	var rect_position : Vector2i = main_tilemap_layer.get_used_rect().position
	var rect_size : Vector2i = main_tilemap_layer.get_used_rect().size
	
	for target in targets:
		target.target_hit.connect(_on_target_hit)
		pass
	
	max_target_health = target_health_stat_template.build_stat()
	target_health_stat = target_health_stat_template.build_stat()
	
	target_health_stat.value_changed.connect(_on_target_health_changed)
	var player : PlayerController = player_scene.instantiate() as PlayerController
	add_child(player)
	arena_ui.initialize()
	#queue_redraw()
	pass

func _process(delta: float) -> void:
	#queue_redraw()
	pass

func _on_target_hit(entity : Entity, data : Dictionary[StringName, Variant]):
	print("TARGET HIT!")
	var target_damage_stat : Stat = entity.stats.get_stat("target_damage")
	if target_damage_stat != null:
		target_health_stat.add(-(target_damage_stat.get_value()))
	pass

func _on_target_health_changed(stat : Stat, context : Dictionary[StringName, Variant]):
	arena_ui.target_health_bar.value = arena_ui.target_health_bar.max_value * (target_health_stat.get_value() / max_target_health.get_value())
	if stat.get_value() <= 0:
		print(" GAME OVER")
	pass

func _draw() -> void:
	#var tile_size : Vector2i = main_tilemap_layer.tile_set.tile_size
	#var rect_position : Vector2i = main_tilemap_layer.get_used_rect().position
	#var rect_size : Vector2i = main_tilemap_layer.get_used_rect().size
	#var arena_center : = ArenaServer.active_arena.main_tilemap_layer.get_used_rect().get_center() *  ArenaServer.active_arena.main_tilemap_layer.tile_set.tile_size 
	#draw_circle((rect_position + (rect_size/2)) * tile_size, 20, Color.BLUE_VIOLET, true)
	#draw_line(Vector2i(-rect_size.x/2, 0) * tile_size, Vector2i(rect_size.x/2, 0) * tile_size, Color.RED, 5)
	#draw_line(-rect_position * tile_size, Vector2.ZERO, Color.BLUE, 5)
	pass

func _exit_tree() -> void:
	target_health_stat = null
