extends MarginContainer

@onready var _progress_bar: ProgressBar = $ProgressBar


func _ready():
	Events.power_level_changed.connect(_on_power_level_changed)


func _on_power_level_changed(current_level: int, total_level: int):
	_progress_bar.value = float(current_level) / float(total_level)
