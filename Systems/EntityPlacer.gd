extends TileMap

@export var maximum_work_distance: int = 3
@export var preview_material: Material

const GROUND_LAYER := 0

var _tracker: EntityTracker
var _player: Player
var _gui: GUI

@onready var _destruction_timer: DestructionTimer = $Timer
@onready var DropPodScene: PackedScene = preload("res://Entities/DropPod.tscn")

var _entity_placer_queue := {}

########## PUBLIC


func setup(gui: GUI, tracker: EntityTracker, player: Player):
	_tracker = tracker
	_player = player
	_gui = gui

	for child in get_children():
		if not child is Entity:
			continue

		var cell_position = local_to_map(to_local(child.global_position))
		child.global_position = to_global(map_to_local(cell_position))

		child._setup(Library.get_blueprint_from(child))
		child._setup_gui(_gui)

		_tracker.place_entities(child, cell_position)


########## INHERATED NODE FUNCTIONS


func _ready():
	_destruction_timer.finish_destruction.connect(_finish_destruction)
	Events.slot_cooldown_finished.connect(_on_quickslot_cooldown_finished)


func _unhandled_input(event: InputEvent):
	_destruction_timer.update_input(event, _get_cell_under_mouse())

	if event.is_action_pressed("left_click"):
		_closw_entity_gui()

		if _has_placable_blueprint():
			if _can_placed_on_cell():
				_request_entity(_get_cell_under_mouse())
			else:
				SoundManager.play("entity_placed_failed")
		elif _is_cell_occupied():
			_show_entity_gui(_get_cell_under_mouse())
		else:
			_player.fire(1, true)

	elif event.is_action_released("left_click"):
		_player.fire(1, false)

	elif event.is_action_pressed("right_click"):
		if _gui.blueprint:
			_gui.destroy_blueprint()

	elif event.is_action_pressed("deconstruct"):
		if _is_cell_occupied():
			_destruction_timer.start_destruction(_get_cell_under_mouse())


func _process(_delta):
	_update_blueprint()
	_update_mouse_position_on_grid()


########## PRIVATE


func _update_blueprint():
	_set_blueprint_color()

	if not _has_placable_blueprint():
		return


func _on_quickslot_cooldown_finished(entity_name: String):
	if not _entity_placer_queue.has(entity_name):
		return

	if _entity_placer_queue[entity_name].is_empty():
		return

	var queue_entry = _entity_placer_queue[entity_name].pop_front()
	var entity := queue_entry["entity"] as Entity
	var blueprint := queue_entry["blueprint"] as BlueprintEntity
	var preview := queue_entry["preview"] as Node

	preview.queue_free()
	_place_entity(entity, blueprint)


func _request_entity(location: Vector2i):
	var entity_name = Library.get_entity_name(_gui.blueprint)
	var entity: Entity = Library.entites[entity_name].instantiate()
	entity.global_position = to_global(map_to_local(location))
	entity.global_rotation = _gui.preview.global_rotation

	entity._setup(_gui.blueprint)
	entity._setup_gui(_gui)

	if _player.energy.energy < entity.data.energy_cost:
		return
	_player.energy.energy -= entity.data.energy_cost

	_tracker.place_entities(entity, location)

	if _gui.blueprint and _gui.blueprint.on_cooldown:
		var preview := _create_preview(entity.position)

		_make_placer_queue_entry(entity_name, entity, _gui.blueprint, preview)

	else:
		_place_entity(entity, _gui.blueprint)


func _place_entity(entity: Entity, blueprint: BlueprintEntity):
	var drop_pod := DropPodScene.instantiate() as DropPod
	drop_pod.global_position = entity.position
	add_child(drop_pod)

	await drop_pod.opened

	add_child(entity)

	SoundManager.play("entity_placed")

	# trigger item changed for cooldown
	blueprint.stack_count += 0


func _create_preview(pos: Vector2) -> Node2D:
	var preview := _gui.preview.duplicate() as Node2D
	preview.global_position = pos
	preview.material = preview_material
	add_child(preview)

	return preview


func _make_placer_queue_entry(
	entity_name: String, entity: Entity, blueprint: BlueprintEntity, preview: Node2D
) -> void:
	if not _entity_placer_queue.has(entity_name):
		_entity_placer_queue[entity_name] = []

	var queue_entry = {"entity": entity, "blueprint": blueprint, "preview": preview}
	_entity_placer_queue[entity_name].append(queue_entry)


func _show_entity_gui(location: Vector2i) -> void:
	var entity: Entity = _tracker.get_entity_at(location)
	if entity != null:
		entity._show_gui()
		_gui.open_entity_ui = entity._get_ui_component()


func _closw_entity_gui() -> void:
	if _gui.open_entity_ui != null:
		_gui.open_entity_ui.hide()
		_gui.open_entity_ui = null


func _finish_destruction(location: Vector2i):
	SoundManager.play("entity_destroyed")

	Events.spawn_effect.emit("destruction", to_global(map_to_local(location)))
	Events.spawn_effect.emit("smoke_explosive", to_global(map_to_local(location)))

	_tracker.remove_entity(location)


func _update_mouse_position_on_grid():
	var global_pos = to_global(map_to_local(_get_cell_under_mouse()))
	var canves_pos = get_canvas_transform() * global_pos

	Events.mouse_grid_position.emit(canves_pos)


func _set_blueprint_color():
	if _gui.blueprint == null:
		return

	if _can_placed_on_cell() and _has_placable_blueprint():
		_gui.preview.material.set_shader_parameter("blend_color", Color(0, 1, 1, 0.7))
	else:
		_gui.preview.material.set_shader_parameter("blend_color", Color(1, 0, 0, 0.7))


########## HELPER


func _has_placable_blueprint() -> bool:
	return _gui.blueprint and _gui.blueprint.placeable


func _is_cell_occupied() -> bool:
	return _tracker.is_cell_occupied(_get_cell_under_mouse())


func _is_ground() -> bool:
	return true


func _is_close_to_player() -> bool:
	var cell_under_mouse = _get_cell_under_mouse()
	var cell_player = local_to_map(to_local(_player.global_position))
	var cell_distance = (cell_player - cell_under_mouse).abs()

	return cell_distance.x <= maximum_work_distance and cell_distance.y <= maximum_work_distance


func _can_placed_on_cell() -> bool:
	return _is_close_to_player() and _is_ground() and not _is_cell_occupied()


func _get_cell_under_mouse() -> Vector2i:
	return local_to_map(to_local(get_global_mouse_position()))
