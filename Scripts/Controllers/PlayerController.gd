class_name PlayerController extends CharacterBody2D


@export var player_entity : PlayerEntityNode
@export var active_ability_controller : ActiveAbilityController
@export var ability_grid : AbilityGrid
@export var ability_tile_inventory : AbilityTileInventory

var input_dir : Vector2

var move_speed : float

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
	
	active_ability_controller.initialize(player_entity.entity)
	
	
	pass

func _process(delta: float) -> void:
	if player_entity.entity.can_move:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	else:
		input_dir = Vector2.ZERO
		pass
	player_entity.entity.global_position = global_position
	pass


func _physics_process(delta: float) -> void:
	if input_dir.length() > 0:
		velocity = input_dir * move_speed 
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	pass
