extends MarginContainer

@onready var _progress_bar: ProgressBar = $ProgressBar
@onready var _particle: GPUParticles2D = $GPUParticles2D


func _ready():
	Events.power_level_changed.connect(_on_power_level_changed)
	Events.leveled_up.connect(_on_level_up)


func _on_power_level_changed(current_level: int, total_level: int):
	_progress_bar.value = float(current_level) / float(total_level)


func _on_level_up() -> void:
	_particle.restart()
	_particle.emitting = true
