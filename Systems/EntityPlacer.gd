extends TileMap

@export var maximum_work_distance: int = 2

const GROUND_LAYER := 0

var _blueprint: BlueprintEntity
var _tracker: EntityTracker
var _ground: TileMap
var _player: CharacterBody2D

@onready var _destruction_timer: DestructionTimer = $Timer
@onready var Library = {
	"StirlingEngine":
	preload("res://Entities/Blueprints/StirlingEngineBlueprint.tscn").instantiate(),
	"Wire": preload("res://Entities/Blueprints/WireBlueprint.tscn").instantiate(),
	"PowerPlant": preload("res://Entities/Blueprints/PowerPlantBlueprint.tscn").instantiate(),
	"Smelter": preload("res://Entities/Blueprints/SmelterBlueprint.tscn").instantiate(),
	"Conveyor": preload("res://Entities/Blueprints/ConveyorBlueprint.tscn").instantiate(),
	"SpikeTrap": preload("res://Entities/Blueprints/SpikeTrapBlueprint.tscn").instantiate(),
	"Crusher": preload("res://Entities/Blueprints/CrusherBlueprint.tscn").instantiate(),
}

########## PUBLIC


func setup(tracker: EntityTracker, ground: TileMap, player: CharacterBody2D):
	_tracker = tracker
	_ground = ground
	_player = player

	Library[Library.StirlingEngine] = preload("res://Entities/Entities/StirlingEngineEntity.tscn")
	Library[Library.Wire] = preload("res://Entities/Entities/WireEntity.tscn")
	Library[Library.PowerPlant] = preload("res://Entities/Entities/PowerPlantEntity.tscn")
	Library[Library.Smelter] = preload("res://Entities/Entities/SmelterEntity.tscn")
	Library[Library.Conveyor] = preload("res://Entities/Entities/ConveyorEntity.tscn")
	Library[Library.SpikeTrap] = preload("res://Entities/Entities/SpikeTrapEntity.tscn")
	Library[Library.Crusher] = preload("res://Entities/Entities/CrusherEntity.tscn")

	for child in get_children():
		if not child is Entity:
			continue

		var cell_position = local_to_map(to_local(child.global_position))
		child.global_position = to_global(map_to_local(cell_position))

		_tracker.place_entities(child, cell_position)


########## INHERATED NODE FUNCTIONS


func _ready():
	_destruction_timer.finish_destruction.connect(_finish_destruction)


func _exit_tree():
	Library.StirlingEngine.queue_free()
	Library.Wire.queue_free()
	Library.PowerPlant.queue_free()
	Library.Smelter.queue_free()
	Library.Conveyor.queue_free()
	Library.SpikeTrap.queue_free()
	Library.Crusher.queue_free()


func _unhandled_input(event: InputEvent):
	_destruction_timer.update_input(event, _get_cell_under_mouse())

	if event.is_action_pressed("left_click"):
		if not _has_placable_blueprint() or not _can_placed_on_cell():
			return

		_place_entity(_get_cell_under_mouse())

	elif event.is_action_pressed("right_click"):
		if _has_placable_blueprint():
			return

		_destruction_timer.start_destruction(_get_cell_under_mouse())

	elif event.is_action_pressed("drop"):
		if not _blueprint:
			return

		remove_child(_blueprint)
		_blueprint = null

	elif event.is_action_pressed("rotate_blueprint"):
		if _has_placable_blueprint() and _blueprint.rotateable:
			_blueprint.global_rotation_degrees += 90

	elif event.is_action_pressed("quickbar_1"):
		_select_blueprint(Library.PowerPlant)

	elif event.is_action_pressed("quickbar_2"):
		_select_blueprint(Library.Wire)

	elif event.is_action_pressed("quickbar_3"):
		_select_blueprint(Library.Smelter)

	elif event.is_action_pressed("quickbar_4"):
		_select_blueprint(Library.Conveyor)

	elif event.is_action_pressed("quickbar_5"):
		_select_blueprint(Library.SpikeTrap)

	elif event.is_action_pressed("quickbar_6"):
		_select_blueprint(Library.Crusher)

	elif event is InputEventMouseMotion:
		if not _has_placable_blueprint():
			return

		_move_blueprint_in_world(_get_cell_under_mouse())


func _select_blueprint(blueprint):
	if _blueprint:
		remove_child(_blueprint)

	_blueprint = blueprint
	add_child(_blueprint)
	_move_blueprint_in_world(_get_cell_under_mouse())


func _process(_delta):
	if _has_placable_blueprint():
		_move_blueprint_in_world(_get_cell_under_mouse())


########## PRIVATE


func _place_entity(location: Vector2i):
	var entity: Entity = Library[_blueprint].instantiate()
	entity.global_position = to_global(map_to_local(location))
	entity.global_rotation = _blueprint.global_rotation
	entity._setup(_blueprint)

	add_child(entity)

	_tracker.place_entities(entity, location)

	if _blueprint is WireBlueprint:
		WireBlueprint.set_sprite_from_direction(
			entity.sprites, _tracker.get_power_neighbors(_get_cell_under_mouse())
		)


func _finish_destruction(location: Vector2i):
	# var entity = _tracker.get_entity_at(location)
	_tracker.remove_entity(location)


func _move_blueprint_in_world(destination: Vector2i):
	_blueprint.global_position = to_global(map_to_local(destination))

	if _can_placed_on_cell():
		_blueprint.modulate = Color.GREEN
	else:
		_blueprint.modulate = Color.RED

	if _blueprint is WireBlueprint:
		WireBlueprint.set_sprite_from_direction(
			_blueprint.sprites, _tracker.get_power_neighbors(_get_cell_under_mouse())
		)


########## HELPER


func _has_placable_blueprint() -> bool:
	return _blueprint and _blueprint.placeable


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
