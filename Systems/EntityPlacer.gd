extends TileMap

@export var maximum_work_distance: int = 2

const GROUND_LAYER := 0

var _tracker: EntityTracker
var _ground: TileMap
var _player: CharacterBody2D
var _gui: GUI

@onready var _destruction_timer: DestructionTimer = $Timer

########## PUBLIC


func setup(gui: GUI, tracker: EntityTracker, ground: TileMap, player: CharacterBody2D):
	_tracker = tracker
	_ground = ground
	_player = player
	_gui = gui

	for child in get_children():
		if not child is Entity:
			continue

		var cell_position = local_to_map(to_local(child.global_position))
		child.global_position = to_global(map_to_local(cell_position))

		child._setup_gui(_gui)

		_tracker.place_entities(child, cell_position)


########## INHERATED NODE FUNCTIONS


func _ready():
	_destruction_timer.finish_destruction.connect(_finish_destruction)


func _unhandled_input(event: InputEvent):
	_destruction_timer.update_input(event, _get_cell_under_mouse())

	if event.is_action_pressed("left_click"):
		if _has_placable_blueprint() and _can_placed_on_cell():
			_place_entity(_get_cell_under_mouse())
		else:
			_show_entity_gui(_get_cell_under_mouse())

	elif event.is_action_pressed("right_click"):
		if not _gui.blueprint:
			_destruction_timer.start_destruction(_get_cell_under_mouse())

	elif event.is_action_pressed("rotate_blueprint"):
		if _has_placable_blueprint() and _gui.blueprint.rotateable:
			_gui.blueprint.global_rotation_degrees += 90


func _process(_delta):
	_update_blueprint()
	_update_mouse_position_on_grid()

	if _has_placable_blueprint():
		_player.set_process_unhandled_input(false)
	else:
		_player.set_process_unhandled_input(true)


########## PRIVATE


func _update_blueprint():
	if not _has_placable_blueprint():
		return

	_set_blueprint_color()

	if _gui.blueprint is WireBlueprint:
		WireBlueprint.set_sprite_from_direction(
			_gui.blueprint.sprites, _tracker.get_power_neighbors(_get_cell_under_mouse())
		)


func _place_entity(location: Vector2i):
	var entity_name = Library.get_entity_name(_gui.blueprint)
	var entity: Entity = Library.entites[entity_name].instantiate()
	entity.global_position = to_global(map_to_local(location))
	entity.global_rotation = _gui.blueprint.global_rotation

	add_child(entity)

	entity._setup(_gui.blueprint)
	entity._setup_gui(_gui)

	_tracker.place_entities(entity, location)

	if _gui.blueprint.stack_count <= 1:
		_gui.destroy_blueprint()
	else:
		_gui.blueprint.stack_count -= 1

	if _gui.blueprint is WireBlueprint:
		WireBlueprint.set_sprite_from_direction(
			entity.sprites, _tracker.get_power_neighbors(_get_cell_under_mouse())
		)


func _show_entity_gui(location: Vector2i):
	if _gui.open_entity_ui != null:
		_gui.open_entity_ui.hide()
		_gui.open_entity_ui = null

	var entity: Entity = _tracker.get_entity_at(location)
	if entity != null:
		entity._show_gui()
		_gui.open_entity_ui = entity._get_ui_component()


func _finish_destruction(location: Vector2i):
	_tracker.remove_entity(location)


func _update_mouse_position_on_grid():
	var global_pos = to_global(map_to_local(_get_cell_under_mouse()))
	var canves_pos = get_canvas_transform() * global_pos

	Events.mouse_grid_position.emit(canves_pos)


func _set_blueprint_color():
	if _can_placed_on_cell():
		_gui.preview_sprite.modulate = Color.GREEN
	else:
		_gui.preview_sprite.modulate = Color.RED


########## HELPER


func _has_placable_blueprint() -> bool:
	return _gui.blueprint and _gui.blueprint.placeable


func _is_cell_occupied() -> bool:
	return _tracker.is_cell_occupied(_get_cell_under_mouse())


func _is_ground() -> bool:
	return _ground.get_cell_source_id(GROUND_LAYER, _get_cell_under_mouse()) == 0


func _is_close_to_player() -> bool:
	var cell_under_mouse = _get_cell_under_mouse()
	var cell_player = local_to_map(to_local(_player.global_position))
	var cell_distance = (cell_player - cell_under_mouse).abs()

	return cell_distance.x <= maximum_work_distance and cell_distance.y <= maximum_work_distance


func _can_placed_on_cell() -> bool:
	return _is_close_to_player() and _is_ground() and not _is_cell_occupied()


func _get_cell_under_mouse() -> Vector2i:
	return local_to_map(to_local(get_global_mouse_position()))
