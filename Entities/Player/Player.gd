extends CharacterBody2D

@export var movement_speed = 300.0

@onready var _animations: Array[AnimatedSprite2D] = [$Model/Body, $Model/Hands]
@onready var _weapons: Array[Weapon] = [$Weapons/PickAxe, $Weapons/Blaster]
@onready var _weapon_timer: Timer = $Weapons/Cooldown
@onready var _drag_objects: DragObjects = $DragObjects
@onready var _ore_collector: OreCollector = $OreCollector


func _ready():
	_ore_collector.ore_collected.connect(_on_ore_collected)


func _process(_delta):
	if _weapon_timer.time_left > 0:
		_animations[1].hide()
	else:
		_animations[1].show()


func _physics_process(_delta):
	var input_direction = (
		Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		. normalized()
	)

	_set_animation(input_direction)

	var speed = movement_speed
	# reduce speed the more bodies are grabed with a maximum of 10
	speed /= min(10, _drag_objects.bodies_grabed() + 1)

	velocity = input_direction * speed

	move_and_slide()


func _unhandled_input(event):
	if event.is_action("left_click"):
		_weapons[0].fire(event.is_pressed())
	if event.is_action("right_click"):
		_weapons[1].fire(event.is_pressed())

	if event.is_action_pressed("grab"):
		_drag_objects.grab()
	if event.is_action_released("grab"):
		_drag_objects.release()


func _on_ore_collected(value):
	var ore: BlueprintEntity = Library.blueprints.Ore.instantiate()
	ore.stack_count = value
	Events.inventory_item_added.emit(ore)


func _set_animation(direction: Vector2):
	for animation in _animations:
		if direction:
			animation.play("walk")
		else:
			animation.play("idle")

		animation.flip_h = _weapons[0].is_right
