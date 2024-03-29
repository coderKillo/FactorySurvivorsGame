class_name Player
extends CharacterBody2D

const MID_LOAD_TRESHOLD = 0.5
const HIGH_LOAD_TRESHOLD = 0.8

@export var movement_speed = 300.0
@export var resources: CollectedResources

@onready var health: Health = $Health
@onready var energy: Energy = $Energy

@onready var _animations: Array[AnimatedSprite2D] = [$Model/Body, $Model/Hands]
@onready var _weapons: Array[Weapon] = [$Weapons/PickAxe, $Weapons/Blaster]
@onready var _weapon_timer: Timer = $Weapons/Cooldown
@onready var _drag_objects: DragObjects = $DragObjects
@onready var _collect_objects: CollectObjects = $CollectObjects
@onready var _selector: BuildingSelector = $BuildingSelector
@onready var _auto_attack_area: Area2D = $AutoattackArea

var load_treshold_slow := 15


func _ready():
	_collect_objects.entity_collected.connect(_on_entity_collected)
	resources.changed.connect(_on_resources_changed)
	_weapons[1].energy_used.connect(_on_weapon_energy_used)
	Events.system_tick.connect(_on_system_tick)


func _process(_delta):
	if _weapon_timer.time_left > 0:
		_animations[1].hide()
	else:
		_animations[1].show()


func _physics_process(_delta):
	fire(0, _auto_attack_area.has_overlapping_bodies())

	var input_direction = (
		Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		. normalized()
	)

	_set_animation(input_direction)

	var speed = movement_speed

	var current_load := resources.ore_amount / float(resources.ore_limit)
	if current_load > MID_LOAD_TRESHOLD:
		speed -= load_treshold_slow
	if current_load > HIGH_LOAD_TRESHOLD:
		speed -= load_treshold_slow
	if _drag_objects.bodies_grabed() > 0:
		speed /= 2

	velocity = input_direction * speed

	move_and_slide()


func _unhandled_input(event):
	if event.is_action_pressed("grab"):
		_drag_objects.grab()
	if event.is_action_released("grab"):
		_drag_objects.release()


func fire(slot: int, pressed: bool) -> void:
	if slot == 1 and energy.energy <= 0:
		return

	_weapons[slot].fire(pressed)


func _on_entity_collected(entity: GroundEntity):
	var entity_name := Library.get_entity_name(entity)

	if not entity_name in Library.blueprints:
		print("no blueprint found for entity:", entity_name)
		return

	SoundManager.play("player_collect")

	resources.ore_amount += entity.data.value


func _on_resources_changed() -> void:
	_collect_objects.set_physics_process(resources.ore_amount <= resources.ore_limit)


func _on_weapon_energy_used(amount):
	energy.energy -= amount

	if energy.energy <= 0:
		_weapons[1].fire(false)


func _on_system_tick(delta: float) -> void:
	if _selector.selected == null:
		return

	var entity := _selector.selected as Entity
	var entity_name := Library.get_entity_name(entity)
	var amount_per_tick := int(600 * delta)

	if entity_name == "Smelter":
		var ore_bucket = entity.get_node_or_null("OreBucket") as Bucket
		var amount = clamp(resources.ore_amount, 0, amount_per_tick)
		resources.ore_amount -= ore_bucket.put(amount)

		var heat_bucket = entity.get_node_or_null("HeatBucket") as Bucket
		heat_bucket.take(int(50 * delta))

		var molt_bucket = entity.get_node_or_null("MoltBucket") as Bucket
		amount = clamp(resources.molt_limit - resources.molt_amount, 0, amount_per_tick)
		resources.molt_amount += molt_bucket.take(amount)

	elif entity_name == "PowerPlant":
		var molt_bucket = entity.get_node_or_null("MoltBucket") as Bucket
		var amount = clamp(resources.molt_amount, 0, amount_per_tick)
		resources.molt_amount -= molt_bucket.put(amount)
		pass


func _set_animation(direction: Vector2):
	for animation in _animations:
		if direction:
			animation.play("walk")
		else:
			animation.play("idle")

		animation.flip_h = _weapons[0].is_right
