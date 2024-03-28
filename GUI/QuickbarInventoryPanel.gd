extends VBoxContainer

@onready var _panel: InventoryPanel = $InventoryPanel
@onready var _progress_bar: TextureProgressBar = $CooldownProgress
@onready var _timer: Timer = $CooldownTimer

var _initialized := false


func _ready():
	_progress_bar.value = 0.0
	_panel.held_item_changed.connect(_on_held_item_changed)
	_timer.timeout.connect(_end_cooldown)


func _process(_delta):
	if _timer.time_left > 0.0:
		_progress_bar.value = _timer.time_left / _timer.wait_time


func _on_held_item_changed(__panel: InventoryPanel, item: BlueprintEntity):
	if item == null:
		return

	if not _initialized:
		_initialized = true
		return

	if not item.placeable:
		return

	start_cooldown(item.data.cooldown)


func start_cooldown(time: float) -> void:
	if _timer.time_left > 0.0:
		return

	if _panel.held_item == null:
		return

	_panel.held_item.placeable = false
	_timer.start(time)


func _end_cooldown() -> void:
	_panel.held_item.placeable = true
