class_name UpgradeSystem
extends RefCounted

const UPGRADE_OPTIONS = 3
const UPGRADE_PATH = "res://Systems/Upgrade/upgrades/"

var _player: Player
var _entity_tracker: EntityTracker
var _gui: GUI

var _upgrades: Array[Upgrade] = []
var _current_requirements: Dictionary = {}


func setup(player: Player, entity_tracker: EntityTracker, gui: GUI):
	_player = player
	_entity_tracker = entity_tracker
	_gui = gui

	_load_upgrades()

	Events.leveled_up.connect(_on_level_up)


func _load_upgrades():
	var dir = DirAccess.open(UPGRADE_PATH)
	if not dir:
		print("Error occured when try to access: ", UPGRADE_PATH)
		return

	dir.list_dir_begin()

	var filename := dir.get_next()
	while filename != "":
		if filename.begins_with("upgrade_"):
			_upgrades.append(load(dir.get_current_dir() + "/" + filename))

		filename = dir.get_next()


func _on_level_up() -> void:
	var upgrade_options: Array[Upgrade] = []
	while len(upgrade_options) < UPGRADE_OPTIONS:
		var upgrade = _get_upgrade()
		if not upgrade in upgrade_options:
			upgrade_options.append(upgrade)

	_gui.display_upgrade(upgrade_options, _apply_upgrade)


func _apply_upgrade(upgrade: Upgrade) -> void:
	_add_requriement(upgrade.type)
	_add_requriement(upgrade.object)

	if upgrade.unique:
		_upgrades.erase(upgrade)

	if upgrade.type == "player":
		var player_upgrade := upgrade as PlayerUpgrade
		player_upgrade.upgrade(_player)

	elif upgrade.type == "weapon":
		var weapon_upgrade := upgrade as WeaponUgrade
		if weapon_upgrade.object == "pickaxe":
			weapon_upgrade.upgrade(_player._weapons[0])
		elif weapon_upgrade.object == "blaster":
			weapon_upgrade.upgrade(_player._weapons[1])
		else:
			printerr(
				(
					"invalid object '%s' in upgrade: %s"
					% [weapon_upgrade.object, weapon_upgrade.upgrade_name()]
				)
			)

	elif upgrade.type == "entity":
		var entity_upgrade := upgrade as EntityUpgrade

		if entity_upgrade.is_new:
			_gui.add_to_quickbar(Library.blueprints[entity_upgrade.object].instantiate())
			return

		for location in _entity_tracker.entities.keys():
			var entity := _entity_tracker.entities[location] as Entity
			if Library.get_entity_name(entity) == entity_upgrade.object:
				entity_upgrade.upgrade_entity(entity)

		for panel in _gui.get_quickbar_panels():
			if panel.held_item == null:
				continue
			if Library.get_entity_name(panel.held_item) == entity_upgrade.object:
				entity_upgrade.upgrade_blueprint(panel.held_item)

	else:
		printerr("invalid type '%s' in upgrade: %s" % [upgrade.type, upgrade.upgrade_name()])


func _add_requriement(type: String) -> void:
	if not _current_requirements.has(type):
		_current_requirements[type] = 0
	_current_requirements[type] += 1


func _get_upgrade() -> Upgrade:
	var valid_upgrades = []
	for upgrade in _upgrades:
		if _requirements_fulfilled(upgrade):
			valid_upgrades.append(upgrade)

	return valid_upgrades.pick_random()


func _requirements_fulfilled(upgrade: Upgrade) -> bool:
	for requirement in upgrade.requirements:
		if requirement not in _current_requirements:
			return false
		if _current_requirements[requirement] < upgrade.requirements[requirement]:
			return false
	return true
