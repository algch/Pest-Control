extends "res://entities/WalkingCharacter.gd"


func _ready():
	max_health = 3.0
	health = max_health
	melee_damage = 0.25
	initial_direction = Vector2.UP
	team = "PLAYER"
	._ready()
