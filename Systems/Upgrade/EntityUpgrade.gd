class_name EntityUpgrade
extends Upgrade

@export var speed := 0.0
@export var damage := 0.0
@export var cooldown := 0.0
@export var is_new := false


func upgrade_entity(entity: Entity):
	entity.speed *= (1.0 - speed)


func upgrade_blueprint(blueprint: BlueprintEntity):
	blueprint.speed *= (1.0 - speed)
	blueprint.cooldown *= (1.0 - cooldown)
