class_name UpgradeSystem
extends RefCounted

const UPGRADE_OPTIONS = 3
const UPGRADE_PATH = "res://Systems/Upgrade/upgrades/"

var _player: Player
var _entity_tracker: EntityTracker
var _gui: GUI

var _current_requirements: Dictionary = {}

# DECKS
var _unused_deck: Array[Upgrade] = []
var _used_deck: Array[Upgrade] = []
var _locked_deck: Array[Upgrade] = []
var _unlock_queue: Array[Upgrade] = []
var _hand: Array[Upgrade] = []


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
			var upgrade := load(dir.get_current_dir() + "/" + filename) as Upgrade

			if upgrade.requirements.is_empty():
				_unused_deck.append(upgrade)
			else:
				_locked_deck.append(upgrade)

		filename = dir.get_next()


func _on_level_up() -> void:
	for upgrade in _locked_deck.duplicate():
		if _requirements_fulfilled(upgrade):
			_locked_deck.erase(upgrade)
			_unlock_queue.append(upgrade)

	_hand.clear()
	_used_deck.shuffle()
	_unused_deck.shuffle()

	# 1. Card
	if not _unused_deck.is_empty():
		_hand.append(_unused_deck.pop_back())
	else:
		_hand.append(_used_deck.pop_back())

	# 2. Card
	if not _unused_deck.is_empty():
		_hand.append(_unused_deck.pop_back())
	else:
		_hand.append(_used_deck.pop_back())

	# 3. Card
	if not _unlock_queue.is_empty():
		_hand.append(_unlock_queue.pop_back())
	elif not _used_deck.is_empty():
		_hand.append(_used_deck.pop_back())
	else:
		_hand.append(_unused_deck.pop_back())

	_hand.shuffle()
	_gui.display_upgrade(_hand, _apply_upgrade)


func _apply_upgrade(upgrade: Upgrade) -> void:
	_hand.erase(upgrade)
	if not upgrade.unique:
		_used_deck.append(upgrade)

	_unused_deck.append_array(_hand)
	_hand.clear()

	_add_requriement(upgrade.type)
	_add_requriement(upgrade.object)

	if upgrade.type == "player":
		upgrade.upgrade(_player)

		Events.spawn_effect.emit("upgrade_explosion", _player.global_position)

	elif upgrade.type == "weapon":
		if upgrade.object == "pickaxe":
			upgrade.upgrade(_player._weapons[0])
		elif upgrade.object == "blaster":
			upgrade.upgrade(_player._weapons[1])
		else:
			printerr(
				"invalid object '%s' in upgrade: %s" % [upgrade.object, upgrade.upgrade_name()]
			)

		Events.spawn_effect.emit("upgrade_explosion", _player.global_position)

	elif upgrade.type == "entity":
		if upgrade.unique:
			_gui.add_to_quickbar(Library.blueprints[upgrade.object].instantiate())
			return

		for location in _entity_tracker.entities.keys():
			var entity := _entity_tracker.entities[location] as Entity
			if Library.get_entity_name(entity) == upgrade.object:
				upgrade.upgrade(entity)
				Events.spawn_effect.emit("upgrade_explosion", entity.global_position)

		for panel in _gui.get_quickbar_panels():
			if panel.held_item == null:
				continue
			print(Library.get_entity_name(panel.held_item))
			print(upgrade.object)
			if Library.get_entity_name(panel.held_item) == upgrade.object:
				upgrade.upgrade(panel.held_item)

	else:
		printerr("invalid type '%s' in upgrade: %s" % [upgrade.type, upgrade.upgrade_name()])


func _add_requriement(type: String) -> void:
	if not _current_requirements.has(type):
		_current_requirements[type] = 0
	_current_requirements[type] += 1


func _requirements_fulfilled(upgrade: Upgrade) -> bool:
	for requirement in upgrade.requirements:
		if requirement not in _current_requirements:
			return false
		if _current_requirements[requirement] < upgrade.requirements[requirement]:
			return false
	return true
