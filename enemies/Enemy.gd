extends "res://entities/WalkingCharacter.gd"

func _ready():
	initial_direction = Vector2.DOWN
	team = "ENEMY"
	._ready()
