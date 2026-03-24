class_name Arena extends Node2D

@export var main_tilemap_layer : TileMapLayer
@export var arena_ui : ArenaUI
@export var player_scene : PackedScene

func _ready():
	ArenaServer.active_arena = self
	var tile_size : Vector2i = main_tilemap_layer.tile_set.tile_size
	var rect_position : Vector2i = main_tilemap_layer.get_used_rect().position
	var rect_size : Vector2i = main_tilemap_layer.get_used_rect().size
	
	var player : PlayerController = player_scene.instantiate() as PlayerController
	add_child(player)
	arena_ui.initialize()
	#queue_redraw()
	pass

func _process(delta: float) -> void:
	#queue_redraw()
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
