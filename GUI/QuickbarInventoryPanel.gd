extends VBoxContainer

@onready var _panel: InventoryPanel = $InventoryPanel
@onready var _progress_bar: TextureProgressBar = $CooldownProgress


func _ready():
	_panel.held_item = Library.blueprints.Smelter.instantiate()
	_panel.held_item.stack_count = 5
	_progress_bar.value = 0.0
