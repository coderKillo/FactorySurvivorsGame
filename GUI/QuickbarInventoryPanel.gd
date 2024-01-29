extends VBoxContainer

@onready var _panel: InventoryPanel = $InventoryPanel
@onready var _progress_bar: TextureProgressBar = $CooldownProgress
@onready var _timer: Timer = $CooldownTimer


func _ready():
	_progress_bar.value = 0.0
	_panel.held_item_changed.connect(_on_held_item_changed)
	_timer.timeout.connect(_end_cooldown)

	# test
	_panel.held_item = Library.blueprints.Smelter.instantiate()
	_panel.held_item.stack_count = 5


func _process(_delta):
	if _timer.time_left > 0.0:
		_progress_bar.value = _timer.time_left / _timer.wait_time


func _on_held_item_changed(__panel: InventoryPanel, item: BlueprintEntity):
	if item == null:
		return

	start_cooldown(2)


func start_cooldown(time: int) -> void:
	if _timer.time_left > 0.0:
		return

	_panel.held_item.placeable = false
	_timer.start(time)


func _end_cooldown() -> void:
	_panel.held_item.placeable = true
