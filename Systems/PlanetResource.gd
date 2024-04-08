class_name PlanetResource
extends Resource

@export var planet_list = []:
	set(value):
		planet_list = value
		changed.emit()


func _init():
	planet_list = [
		{
			name = "Nova-339A7I",
			color = "red",
			resource = 430_000_000,
			max_resource = 430_000_000,
		},
		{
			name = "Etheria-11S55E",
			color = "yellow",
			resource = 470_000_000,
			max_resource = 470_000_000,
		},
		{
			name = "Nebula-AA5B65",
			color = "purple",
			resource = 530_000_000,
			max_resource = 530_000_000,
		},
		{
			name = "Celestia-2X22I8",
			color = "green",
			resource = 590_000_000,
			max_resource = 590_000_000,
		},
		{
			name = "Lumina-3S44Y2",
			color = "grey",
			resource = 610_000_000,
			max_resource = 610_000_000,
		},
		{
			name = "Chromo-28XX61",
			color = "red",
			resource = 670_000_000,
			max_resource = 670_000_000,
		},
		{
			name = "Xeno-38JK6",
			color = "blue",
			resource = 710_000_000,
			max_resource = 710_000_000,
		},
		{
			name = "Orion-1A5BX0",
			color = "yellow",
			resource = 730_000_000,
			max_resource = 730_000_000,
		},
		{
			name = "Galacta-9BB7I",
			color = "purple",
			resource = 790_000_000,
			max_resource = 790_000_000,
		},
		{
			name = "Aurora-K33A9",
			color = "blue",
			resource = 830_000_000,
			max_resource = 830_000_000,
			max_resource = 480000000,
		},
		{
			name = "Terra-E7F5X2",
			color = "brown",
			resource = 890_000_000,
			max_resource = 890_000_000,
			max_resource = 480000000,
		},
		{
			name = "Solaris-XXY1E4",
			color = "yellow",
			resource = 970_000_000,
			max_resource = 970_000_000,
		},
		{
			name = "Cosmos-X3F00A",
			color = "purple",
			resource = 1_010_000_000,
			max_resource = 1_010_000_000,
		},
		{
			name = "Axis-99XP0",
			color = "red",
			resource = 1_030_000_000,
			max_resource = 1_030_000_000,
		},
		{
			name = "Epsilon-X56JJ",
			color = "green",
			resource = 1_070_000_000,
			max_resource = 1_070_000_000,
		},
		{
			name = "Nebulus-4SZ12",
			color = "purple",
			resource = 1_090_000_000,
			max_resource = 1_090_000_000,
		},
		{
			name = "Zenith-67BB0X",
			color = "red",
			resource = 1_130_000_000,
			max_resource = 1_130_000_000,
		},
		{
			name = "Hyperia-F8X999",
			color = "blue",
			resource = 1_270_000_000,
			max_resource = 1_270_000_000,
		},
		{
			name = "Astro-A22VV8",
			color = "purple",
			resource = 1_390_000_000,
			max_resource = 1_390_000_000,
		},
		{
			name = "Chrona-L76XX5",
			color = "grey",
			resource = 1_670_000_000,
			max_resource = 1_670_000_000,
		},
	]
