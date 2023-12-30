class_name Types
extends RefCounted

enum Direction { RIGHT = 1, DOWN = 2, LEFT = 4, UP = 8 }

const NEIGHBORS = {
	Direction.RIGHT: Vector2i.RIGHT,
	Direction.DOWN: Vector2i.DOWN,
	Direction.LEFT: Vector2i.LEFT,
	Direction.UP: Vector2i.UP,
}

const POWER_MOVERS = "power_movers"
const POWER_RECEIVERS = "power_receivers"
const POWER_SOURCES = "power_sources"

const MATERIAL_PROVIDER = "material_provider"
const MATERIAL_RECEIVER = "material_receiver"
