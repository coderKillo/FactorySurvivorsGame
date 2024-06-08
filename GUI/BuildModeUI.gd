class_name BuildModeUI
extends MarginContainer

const HALF_CELL_SIZE = Vector2(8, 8)

@onready var _icon: GUISprite = $GUISprite
@onready var _tilemap: TileMap = $TileMap


func _ready():
	Events.player_grid_position.connect(_on_player_grid_position)


func _on_player_grid_position(pos: Vector2):
	_tilemap.global_position = pos + HALF_CELL_SIZE


func set_pause_icon(paused: bool) -> void:
	if paused:
		_icon.region_rect.position.x = 32
		_tilemap.show()
	else:
		_icon.region_rect.position.x = 0
		_tilemap.hide()
