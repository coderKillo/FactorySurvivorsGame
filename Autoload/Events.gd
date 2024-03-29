extends Node2D

signal entity_placed(entity: Entity, cellv: Vector2)

signal entity_removed(entity: Entity, cellv: Vector2)

signal ground_entity_spawn(entity_name: String, pos: Vector2, color: String)

signal system_tick(delta: float)

signal enemy_spawn(enemy: Enemy)

signal enemy_died(enemy: Enemy)

signal enemies_attack(attacking: bool)

signal mouse_grid_position(pos: Vector2)

signal inventory_item_added(blueprint: BlueprintEntity)

signal power_produced(total_produced: int, produced: int, used: int)

signal leveled_up

signal spawn_effect(name: String, position: Vector2)

signal spawn_effect_rotated(name: String, position: Vector2, degree: float)

signal frame_freeze

signal camera_shake(amount: float)
