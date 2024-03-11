class_name MonsterBuilder
extends RefCounted

const TEMPLATE_PATH = "res://Entities/Enemies/Templates"
const PARTS_PATH = "res://Entities/Enemies/Parts"

var BaseEnemy := preload("res://Entities/Enemies/BaseEnemy.tscn")

var _parts: Dictionary
var _templates: Dictionary


func _init():
	_parts = _load(PARTS_PATH, "part_")
	_templates = _load(TEMPLATE_PATH, "template_")


func get_random_template() -> EnemyTemplate:
	return _templates.values().pick_random()


func build(enemy: Enemy, template: EnemyTemplate):
	if _templates.is_empty():
		printerr("build enemy faild: no template found")
		return

	if not enemy.is_node_ready():
		await enemy.ready

	enemy.health.max_health = template.health
	enemy.speed = template.speed
	enemy.damage = template.damage
	enemy.destruction_count = template.destruction_count
	enemy.color = template.ore_color

	for part_name in template.parts.keys():
		if not part_name in _parts:
			print("Error could not find part ", part_name)
			continue

		var part := _parts[part_name].instantiate() as AnimatedSprite2D
		part.material = RecolorTable.create_recolor_material_from(template.parts[part_name])
		enemy.model.add_part(part)


func _load(path: String, prefix: String) -> Dictionary:
	var dir = DirAccess.open(path)
	var result = {}
	if not dir:
		print("Error occured when try to access: ", path)
		return result

	dir.list_dir_begin()

	var filename := dir.get_next()
	while filename != "":
		if filename.begins_with(prefix):
			var key = filename.replace(prefix, "").replace(".tscn", "")
			result[key] = load(dir.get_current_dir() + "/" + filename)

		filename = dir.get_next()

	return result
