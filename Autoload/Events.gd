extends Node2D

signal entity_placed(entity: Entity, cellv: Vector2)

signal entity_removed(entity: Entity, cellv: Vector2)

signal ground_entity_spawn(entity_name: String, pos: Vector2)

signal system_tick(delta)

signal enemy_spawn(enemy: Enemy)

signal enemy_died(enemy: Enemy)

signal enemies_attack(attacking: bool)

signal mouse_grid_position(pos: Vector2)

signal inventory_item_added(blueprint: BlueprintEntity)

signal power_produced(total_produced: int, produced: int, used: int)

signal leveled_up
