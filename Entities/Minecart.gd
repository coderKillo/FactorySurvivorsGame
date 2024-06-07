extends GroundEntity

@onready var _collect_objects: CollectObjects = $CollectObjects
@onready var _selector: BuildingSelector = $BuildingSelector
@onready var _load_spirte: Sprite2D = $LoadSprite

var resources: CollectedResources


func _ready():
	is_draggable = true

	resources = CollectedResources.new()
	resources.ore_limit = UpgradeData.player_data.ore_limit
	resources.molt_limit = UpgradeData.player_data.molt_limit

	_collect_objects.entity_collected.connect(_on_entity_collected)
	resources.changed.connect(_on_resources_changed)
	Events.system_tick.connect(_on_system_tick)
	Events.upgrade_data_changed.connect(_on_upgrade_data_changed)


func _on_entity_collected(entity: GroundEntity):
	var entity_name := Library.get_entity_name(entity)

	if not entity_name in Library.blueprints:
		print("no blueprint found for entity:", entity_name)
		return

	SoundManager.play("player_collect")

	resources.ore_amount += entity.data.value


func _on_resources_changed() -> void:
	_collect_objects.active = (resources.ore_amount <= resources.ore_limit)

	if resources.ore_amount > resources.molt_amount:
		_set_load_sprite(float(resources.ore_amount) / resources.ore_limit)
	else:
		_set_load_sprite(float(resources.molt_amount) / resources.molt_limit)


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


func _on_upgrade_data_changed() -> void:
	resources.ore_limit = UpgradeData.player_data.ore_limit
	resources.molt_limit = UpgradeData.player_data.molt_limit


func _set_load_sprite(percent: float) -> void:
	percent = clamp(percent, 0.0, 1.0)

	var min_region_offset := 162
	var max_region_offset := 169

	_load_spirte.region_rect.position.y = lerp(min_region_offset, max_region_offset, percent)
