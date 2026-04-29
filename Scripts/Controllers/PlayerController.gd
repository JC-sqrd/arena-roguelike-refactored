class_name PlayerController extends CharacterBody2D


@export var player_entity : PlayerEntityNode
@export var active_ability_controller_manager : ActiveAbilityControllerManager
@export var grid_ability_controller_manager : GridAbilityControllerManager
@export var ability_grid : AbilityGrid
@export var ability_tile_inventory : AbilityGrid
@export var interactable_detector : InteractableDetector
@export var stun_timer : Timer

var _original_coll_layer : int = 0

var input_dir : Vector2

var move_speed : float


signal initialized_grids(ability_grid : AbilityGrid, ability_inventory : AbilityGrid)

func _init() -> void:
	PlayerServer.main_player = self

func _ready():
	player_entity.initialize(get_rid())
	move_speed = player_entity.entity.stats.get_stat("move_speed").get_value()
	
	ability_tile_inventory = ability_tile_inventory.duplicate(true)
	ability_tile_inventory.generate_grid()
	
	ability_tile_inventory.initialize()
	
	ability_grid = ability_grid.duplicate(true)
	
	ability_grid.generate_grid()
	
	grid_ability_controller_manager.initialize(player_entity.entity, ability_grid)
	
	ability_grid.initialize()
	
	initialized_grids.emit(ability_grid, ability_tile_inventory)
	
	active_ability_controller_manager.initialize(player_entity.entity)
	#active_ability_controller.initialize(player_entity.entity)
	
	interactable_detector.initialize(player_entity.entity, self)
	
	player_entity.entity.health_manager.health_depleted.connect(_on_health_depleted)
	
	stun_timer.timeout.connect(_on_stun_timeout)
	
	_original_coll_layer = collision_layer
	
	EntityServer.register_entity(player_entity.entity.entity_rid, player_entity.entity)
	pass

func _process(delta: float) -> void:
	if player_entity.entity.can_move:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	else:
		input_dir = Vector2.ZERO
		pass
	player_entity.entity.global_position = global_position
	pass

func _on_health_depleted(context : Dictionary[StringName, Variant]):
	player_entity.entity.can_move = false
	player_entity.entity.can_cast = false
	player_entity.entity.can_attack = false
	player_entity.entity.velocity = Vector2.ZERO
	collision_layer = 0
	stun_timer.start(3)
	pass

func _on_stun_timeout():
	player_entity.entity.can_move = true
	player_entity.entity.can_cast = true
	player_entity.entity.can_attack = true
	collision_layer = _original_coll_layer
	player_entity.entity.health_manager.restore_health()
	var dict : Dictionary[StringName, Variant] = {}
	player_entity.entity.health_manager.current_health.value_changed.emit(player_entity.entity.health_manager.current_health, dict)
	pass

func _physics_process(delta: float) -> void:
	if player_entity.entity.can_move:
		if input_dir.length() > 0:
			player_entity.entity.velocity = input_dir * move_speed
			#velocity = player_entity.entity.velocity 
		else:
			player_entity.entity.velocity = Vector2.ZERO
			#velocity = player_entity.entity.velocity
	
	velocity = player_entity.entity.velocity
	#global_position = player_entity.entity.global_position
	move_and_slide()
	player_entity.entity.global_position = global_position
	pass


func _exit_tree() -> void:
	if player_entity.entity != null:
		EntityServer.to_free(player_entity.entity.entity_rid)
	pass
