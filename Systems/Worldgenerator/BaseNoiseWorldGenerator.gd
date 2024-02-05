class_name BaseNoiseWorldGenerator
extends WorldGenerator

const SOURCE_ID = 0
const LAYER = 0

@export var alternate_tiles: Dictionary
@export var modulate_color: Gradient

@onready var _tilemap: TileMap = $TileMap

var _default_tile := Vector2i(5, 3)


func _ready():
	_target = $Player
	_tilemap.modulate = modulate_color.get_color(randi() % modulate_color.get_point_count())
	generate()


func _generate_sector(x: int, y: int) -> void:
	_rng.seed = _make_new_seed(x, y)

	var cell_offset = Vector2i(x, y) * _sector_cell_count

	# fill
	for x_cell in range(0, _sector_cell_count):
		for y_cell in range(0, _sector_cell_count):
			_tilemap.set_cell(
				LAYER, Vector2i(x_cell, y_cell) + cell_offset, SOURCE_ID, _default_tile
			)

	# highlights
	for source_id in alternate_tiles:
		_place_random_highlight(source_id, alternate_tiles[source_id], cell_offset)


func _draw():
	for x in range(-_half_sector_count, _half_sector_count):
		for y in range(-_half_sector_count, _half_sector_count):
			var cell_offset := (Vector2(x, y) + _current_sector) * _sector_cell_count

			var rect = Rect2(cell_offset * quadrad_cell_size, Vector2(sector_size, sector_size))
			draw_rect(rect, Color.RED, false, 1.0)


func _place_random_highlight(source_id: int, occurence: int, offset: Vector2i):
	pass


func _clear_sector(x: int, y: int) -> void:
	var cell_offset = Vector2i(x, y) * _sector_cell_count

	# fill
	for x_cell in range(0, _sector_cell_count):
		for y_cell in range(0, _sector_cell_count):
			_tilemap.erase_cell(LAYER, Vector2i(x_cell, y_cell) + cell_offset)
