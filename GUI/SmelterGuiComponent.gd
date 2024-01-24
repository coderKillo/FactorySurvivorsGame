class_name SmelterGuiComponent
extends BaseGuiComponent

@export var heat_provider: HeatProvider

@onready var _progress_bar: ProgressBar = $PanelContainer/MarginContainer/HBoxContainer/ProgressBar


func _ready():
	assert(heat_provider, "missing heat provider in gui")
	assert("slot" in owner, "missing slot in owner of gui")

	heat_provider.update_amount.connect(_on_heat_provided_update_amount)

	panels = [$PanelContainer/MarginContainer/HBoxContainer/InventoryPanel]
	panels[0].item_filter = "Ore"

	owner.slot.bind(panels[0])

	_progress_bar.value = 0.0


func _on_heat_provided_update_amount(amount: int, diff: int) -> void:
	if diff > 0:
		_progress_bar.max_value = float(amount)
		_progress_bar.value = float(amount)
	elif diff < 0:
		_progress_bar.value = float(amount)
