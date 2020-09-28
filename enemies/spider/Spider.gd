extends "res://enemies/Enemy.gd"

func _ready():
	max_health = 3.0
	health = max_health
	melee_damage = 0.5
	._ready()
