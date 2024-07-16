extends Node2D


class PlayerData:
	var ore_limit: int = 500
	var max_health: int = 40
	var max_energy: int = 100
	var max_bodies: int = 1


var player_data := PlayerData.new()


class PickaxeData:
	var damage: int = 10
	var max_hit: int = 1
	var weapon_size: float = 1.0
	var fire_rate: float = 1.0


var pickaxe_data := PickaxeData.new()


class BlasterData:
	var damage: int = 6
	var fire_rate: float = 3.0
	var cost_reduction: int = 0
	var ProjectileScene := preload("res://Systems/Weapon/Projectile.tscn")
	var projectile_scale: float = 1.0


var blaster_data := BlasterData.new()

var entites_data := {
	"Conveyor":
	EntityData.new(
		{
			cooldown = 4.0,
			energy_cost = 150,
			speed = 15.0,
			damage = 1,
			stack_size = 10,
			value = 10,
			amount = 1,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"Crusher":
	EntityData.new(
		{
			cooldown = 20.0,
			energy_cost = 1500,
			speed = 1.0,
			damage = 1,
			stack_size = 10,
			value = 10,
			amount = 1,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"Drill":
	EntityData.new(
		{
			cooldown = 5.0,
			energy_cost = 500,
			speed = 1.0,
			damage = 10,
			stack_size = 10,
			value = 1,
			amount = 1,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"EnemyCorpse":
	EntityData.new(
		{
			cooldown = 2.0,
			energy_cost = 0,
			speed = 1.0,
			damage = 1,
			stack_size = 999,
			value = 10,
			amount = 1,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"ExplosionTrap":
	EntityData.new(
		{
			cooldown = 20.0,
			energy_cost = 1000,
			speed = 1.0,
			damage = 25,
			stack_size = 10,
			value = 5,
			amount = 0,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"Ore":
	EntityData.new(
		{
			cooldown = 2.0,
			energy_cost = 0,
			speed = 1.0,
			damage = 1,
			stack_size = 999,
			value = 200,
			amount = 1,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"PowerPlant":
	EntityData.new(
		{
			cooldown = 30.0,
			energy_cost = 5000,
			speed = 1.0,
			damage = 1,
			stack_size = 10,
			value = 15,
			amount = 10,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"Smelter":
	EntityData.new(
		{
			cooldown = 60.0,
			energy_cost = 10000,
			speed = 1.0,
			damage = 1,
			stack_size = 10,
			value = 20,
			amount = 10,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"SpikeTrap":
	EntityData.new(
		{
			cooldown = 10.0,
			energy_cost = 500,
			speed = 1.0,
			damage = 15,
			stack_size = 10,
			value = 2,
			amount = 0,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
	"Turret":
	EntityData.new(
		{
			cooldown = 20.0,
			energy_cost = 3500,
			speed = 1.0,
			damage = 10,
			stack_size = 10,
			value = 4,
			amount = 1,
			upgrade_1 = false,
			upgrade_2 = false
		}
	),
}


func get_update_object(type: String, object: String) -> Object:
	if type == "player":
		return player_data
	elif type == "weapon" and object == "pickaxe":
		return pickaxe_data
	elif type == "weapon" and object == "blaster":
		return blaster_data
	elif type == "entity" and entites_data.has(object):
		return entites_data[object]

	printerr("invalid type '%s' and object %s" % [type, object])
	return null
