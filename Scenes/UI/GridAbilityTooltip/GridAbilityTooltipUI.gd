class_name GridAbilityTooltipUI extends PanelContainer

@onready var ability_tile_texture_rect: AbilityTileTextureRect = %AbilityTileTextureRect
@onready var name_label: RichTextLabel = %NameLabel
@onready var detail_label: RichTextLabel = %DetailLabel
@onready var level_label: RichTextLabel = %LevelLabel

var ability_tile : AbilityTile

func _ready() -> void:
	ability_tile_texture_rect.initialize(ability_tile, Vector2i(0,0))
	name_label.text = ability_tile.name
	detail_label.text = ability_tile.ability_details
	print("TOOLTIP READY")
	level_label.text = "LVL " + str(ability_tile.level)
