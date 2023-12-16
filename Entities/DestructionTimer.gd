class_name DestructionTimer
extends Timer

@export var destruction_time: float = 0.5

var _current_destruction_location: Vector2i

signal finish_destruction(cellv: Vector2i)


func start_destruction(location: Vector2i):
	timeout.connect(_finish_destruction.bind(location), CONNECT_ONE_SHOT)
	start(destruction_time)
	_current_destruction_location = location


func update_input(event: InputEvent, cell_under_mouse: Vector2i):
	if event is InputEventMouseButton:
		_about_destruction()
	if event is InputEventMouseMotion and cell_under_mouse != _current_destruction_location:
		_about_destruction()


func _about_destruction():
	if timeout.is_connected(_finish_destruction):
		timeout.disconnect(_finish_destruction)

	stop()
	_current_destruction_location = Vector2i()


func _finish_destruction(location: Vector2i):
	finish_destruction.emit(location)
