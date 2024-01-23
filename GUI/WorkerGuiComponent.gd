extends BaseGuiComponent

@export var worker: WorkComponent

@onready var _progress_bar: ProgressBar = $VBoxContainer/ProgressBar


func _ready():
	assert(worker, "missing work component")

	panels = [$VBoxContainer/HBoxContainer/InputPanel, $VBoxContainer/HBoxContainer/OutputPanel]
	panels[worker.INPUT_SLOT].item_filter = worker.input_name
	panels[worker.OUTPUT_SLOT].item_filter = worker.output_name

	_progress_bar.value = 0
	_progress_bar.max_value = 1

	worker.update_progress.connect(_on_update_progress)
	worker.add_inventory_item.connect(_on_add_inventory_item)
	worker.remove_inventory_item.connect(_on_remove_inventory_item)


func _on_update_progress(percent: float) -> void:
	_progress_bar.value = percent


func _on_add_inventory_item(slot: int) -> void:
	if slot == worker.INPUT_SLOT:
		_add_blueprint_to_panel(worker.input_name, panels[worker.INPUT_SLOT])
	elif slot == worker.OUTPUT_SLOT:
		_add_blueprint_to_panel(worker.output_name, panels[worker.OUTPUT_SLOT])


func _on_remove_inventory_item(slot: int) -> void:
	if slot == worker.INPUT_SLOT:
		_remove_blueprint_from_panel(panels[worker.INPUT_SLOT])
	elif slot == worker.OUTPUT_SLOT:
		_remove_blueprint_from_panel(panels[worker.OUTPUT_SLOT])
