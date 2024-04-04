class_name PlanetResource
extends Resource

var planet_list = []

func _init():
	planet_list = [
		{
			name = "Merkur",
			color = "red",
			resources = 1000,
			max_resources = 1000,
		},
		{
			name = "Venus",
			color = "yellow",
			resources = 1000,
			max_resources = 2000,
		},
		{
			name = "Earth",
			color = "blue",
			resources = 1000,
			max_resources = 3000,
		},
		{
			name = "Mars",
			color = "red",
			resources = 1000,
			max_resources = 4000,
		},
		{
			name = "Saturn",
			color = "yellow",
			resources = 1000,
			max_resources = 5000,
		},
	]