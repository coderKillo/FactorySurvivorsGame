class_name EntityUpgrade
extends Upgrade

@export var speed := 0.0
@export var damage := 0.0
@export var value := 0
@export var cooldown := 0.0
@export var is_new := false


func upgrade_entity(entity: Entity):
	entity.speed += speed
	entity.value += value


func upgrade_blueprint(blueprint: BlueprintEntity):
	blueprint.speed += speed
	blueprint.value += value
	blueprint.cooldown -= cooldown
	blueprint.cooldown = max(0.05, blueprint.cooldown)
