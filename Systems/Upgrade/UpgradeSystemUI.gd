class_name UpgradeSystemUI
extends MarginContainer

@onready var UpgradePanelScene := preload("res://GUI/UpgradePanel.tscn")

@onready var _panel_container: Control = $HBoxContainer
@onready var _icons := {
	"weapon": preload("res://Shared/update_weapon_icon.png"),
	"player": preload("res://Shared/update_player_icon.png"),
	"entity": preload("res://Shared/update_entity_icon.png"),
}

var _active = false
var _upgrade_count = {}


func display_options(upgrades: Array[Upgrade], callback: Callable):
	get_tree().paused = true
	_active = false

	for upgrade in upgrades:
		var panel := _create_panel(upgrade)

		panel.mouse_entered.connect(_on_mouse_enter.bind(panel))
		panel.mouse_exited.connect(_on_mouse_exit.bind(panel))
		panel.mouse_clicked.connect(_on_mouse_clicked.bind(upgrade, callback))

	var transition = _create_transition()
	await transition.finished

	_active = true


func _create_transition() -> Tween:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_method(
		func(progress): material.set_shader_parameter("transition_progress", progress),
		0.0,  # start
		1.0,  # end
		1.0  # time
	)

	return tween


func _create_panel(upgrade: Upgrade) -> UpgradePanel:
	var panel := UpgradePanelScene.instantiate() as UpgradePanel
	_panel_container.add_child(panel)

	_set_description(panel, upgrade)
	_set_icon(panel, upgrade)
	_set_title(panel, upgrade)
	_set_quality(panel, upgrade)

	return panel


func _set_title(panel: UpgradePanel, upgrade: Upgrade):
	if not upgrade.unique:
		panel.title.text = upgrade.title + " " + _into_roman(_get_upgrade_count(upgrade))
	else:
		panel.title.text = upgrade.title


func _set_icon(panel: UpgradePanel, upgrade: Upgrade):
	if upgrade.type in _icons:
		panel.icon.texture = _icons[upgrade.type]
	else:
		printerr("could not find icon for upgrade type: ", upgrade.type)


func _set_description(panel: UpgradePanel, upgrade: Upgrade):
	var properties: Array = []
	for property in upgrade.get_property_list():
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			properties.append([property["name"], upgrade.get(property["name"])])

	panel.text.text = upgrade.description.format(properties)


func _set_quality(panel: UpgradePanel, upgrade: Upgrade):
	print(upgrade.quality)
	if upgrade.quality == Types.UpgradeQuality.COMMON:
		panel.recolor("green")
	if upgrade.quality == Types.UpgradeQuality.RARE:
		pass
	if upgrade.quality == Types.UpgradeQuality.EPIC:
		panel.recolor("purple")
	if upgrade.quality == Types.UpgradeQuality.UNIQUE:
		panel.make_shiny()


func _on_mouse_enter(panel: UpgradePanel):
	panel.modulate = Color(1.5, 1.5, 1.5, 1)


func _on_mouse_exit(panel: UpgradePanel):
	panel.modulate = Color.WHITE


func _on_mouse_clicked(upgrade: Upgrade, callback: Callable):
	if not _active:
		return

	get_tree().paused = false

	if not upgrade.unique:
		_upgrade_count[upgrade.upgrade_name()] += 1

	for child in _panel_container.get_children():
		child.queue_free()

	callback.call(upgrade)


func _get_upgrade_count(upgrade: Upgrade) -> int:
	var upgrade_name = upgrade.upgrade_name()
	if not _upgrade_count.has(upgrade_name):
		_upgrade_count[upgrade_name] = 1

	return _upgrade_count[upgrade_name]


# convert greek number to roman number until 999
func _into_roman(number: int) -> String:
	if number > 999:
		return str(number)

	var roman_map = [
		[500, "D"],
		[400, "CD"],
		[100, "C"],
		[90, "XC"],
		[50, "L"],
		[40, "XL"],
		[10, "X"],
		[9, "IX"],
		[5, "V"],
		[4, "IV"],
		[1, "I"],
	]

	var result := ""
	while number > 0:
		for pair in roman_map:
			while number >= pair[0]:
				result += pair[1]
				number -= pair[0]
	return result
