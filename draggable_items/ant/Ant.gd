extends "res://entities/WalkingCharacter.gd"


var cost = 50

class_name Ant

func _ready():
	max_health = 3.0
	health = max_health
	melee_damage = 0.25
	initial_direction = Vector2.UP
	team = "PLAYER"
	._ready()
