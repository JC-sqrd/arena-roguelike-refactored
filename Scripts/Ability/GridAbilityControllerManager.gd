class_name GridAbilityControllerManager extends AbilityControllerManager


var controllers : Dictionary[AbilityTile, GridAbilityController]
var ability_grid : AbilityGrid
var caster : Entity



func initialize(caster : Entity, ability_grid : AbilityGrid):
	self.caster = caster
	self.ability_grid = ability_grid
	self.ability_grid.grid_changed.connect(_on_grid_changed)
	self.ability_grid.placed_tile.connect(_on_placed_tile)
	self.ability_grid.removed_tile.connect(_on_removed_tile)
	
	for tile in ability_grid.ability_tiles:
		var controller : GridAbilityController = tile.ability_scene.instantiate() as GridAbilityController
		controllers[tile] = controller
		add_child(controller)
		controller.initialize(caster)
	pass

func add_controller(tile : AbilityTile, ability_controller : GridAbilityController):
	controllers[tile] = (ability_controller)
	pass

func _on_grid_changed():
	pass



func _on_placed_tile(tile : AbilityTile, coord : Vector2i):
	var controller : GridAbilityController = tile.build_ability_controller()
	controllers[tile] = controller
	add_child(controller)
	controller.initialize(caster)
	pass

func _on_removed_tile(tile : AbilityTile, coord : Vector2i):
	if controllers.has(tile):
		var controller : GridAbilityController = controllers[tile]
		controllers.erase(tile)
		remove_child(controller)
		pass
	pass
