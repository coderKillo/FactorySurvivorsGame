class_name EnemyPlacer
extends Node2D

@export var time_between_waves := 15.0  # sek
@export var time_between_enemies := 0.1
@export var time_between_groups := 1.0
@export var spawn_distance := 10
@export var enemies_per_group := Vector2i.ZERO
@export var groups_per_wave := Vector2i.ZERO

var _player: Node2D = null
var _monster_builder := MonsterBuilder.new()
var _current_enemy_count := 0

@onready var _spawn_timer: Timer = $SpawnTimer


func _ready():
	randomize()
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	Events.enemy_died.connect(_on_enemy_died)


func setup(player: Node2D):
	_player = player
	_start()


func _start() -> void:
	_spawn_wave()


func _on_spawn_timer_timeout():
	_spawn_wave()


func _on_enemy_died(enemy):
	_spawn_enemy_corps(enemy)

	_current_enemy_count -= 1
	if _current_enemy_count <= 0:
		Events.enemies_attack.emit(false)
		Events.leveled_up.emit()
		_spawn_timer.start(time_between_waves)


func _spawn_enemy_corps(enemy: Enemy) -> void:
	var corps: Entity = Library.entites.EnemyCorps.instantiate()

	corps.global_position = enemy.global_position

	var destruction_component := (
		corps.get_node_or_null("DestructionComponent") as DestructionComponent
	)
	if destruction_component != null:
		destruction_component.pickup_count = enemy.destruction_count
		destruction_component.ore_color = enemy.color

	for sprite in enemy.model.get_death_sprite():
		corps.add_child(sprite)

	add_child(corps)


func _spawn_wave():
	Events.enemies_attack.emit(true)

	for _i in range(randi_range(groups_per_wave.x, groups_per_wave.y)):
		await get_tree().create_timer(time_between_groups).timeout
		_spawn_enemy_group()


func _spawn_enemy_group():
	if _player == null:
		return

	var spawn_angle = randi() % 360
	var template := _monster_builder.get_random_template()

	for _i in range(randi_range(enemies_per_group.x, enemies_per_group.y)):
		await get_tree().create_timer(time_between_enemies).timeout

		var angle = randi_range(spawn_angle - 30, spawn_angle + 30)
		var spawn_pos = _player.position + (Vector2.from_angle(deg_to_rad(angle)) * spawn_distance)

		var enemy: Enemy = _monster_builder.BaseEnemy.instantiate()
		enemy.position = spawn_pos
		enemy.target = _player

		add_child(enemy)

		_monster_builder.build(enemy, template)

		_current_enemy_count += 1
		Events.enemy_spawn.emit(enemy)
