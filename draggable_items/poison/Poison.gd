extends StaticBody2D


signal destroyed(cell_index)

var team = "PLAYER"
var charges = 3
var poison_time = 1
var poison_damage = 0.5
var cost = 30
var current_cell = null

class_name Poison

func handle_melee_attack(attacker):
	if is_instance_valid(attacker) and attacker.has_method("handle_poisoned"):
		attacker.handle_poisoned(self)
	emit_signal("destroyed", current_cell)
	queue_free()
