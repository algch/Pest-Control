extends StaticBody2D


var team = "PLAYER"
var charges = 3
var poison_time = 1
var poison_damage = 0.5

func handle_melee_attack(attacker):
	if is_instance_valid(attacker) and attacker.has_method("handle_poisoned"):
		attacker.handle_poisoned(self)
	queue_free()
