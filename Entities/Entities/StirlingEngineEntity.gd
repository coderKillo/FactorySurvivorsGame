extends Entity

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	animation.play()
