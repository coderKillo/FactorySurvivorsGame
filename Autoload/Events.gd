extends Node2D

signal entity_placed(entity: Entity, cellv: Vector2)

signal entity_removed(entity: Entity, cellv: Vector2)

signal system_tick(delta)

signal enemy_spawn(enemy: Enemy)

signal enemy_died(enemy: Enemy)
