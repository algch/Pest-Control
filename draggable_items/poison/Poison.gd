extends StaticBody2D


signal destroyed(cell_index)

var team = "PLAYER"
var charges = 3
var poison_time = 1
var poison_damage = 0.5
var cost = 30
var current_cell = null
var max_health = 5.0
var health = max_health setget set_health

class_name Poison

func set_health(new_health):
	if new_health <= 0:
		emit_signal("destroyed", current_cell)
		queue_free()

	health = new_health

func handle_melee_attack(attacker):
	self.health -= attacker.melee_damage
	if self.health <= 0 and is_instance_valid(attacker) and attacker.has_method("handle_poisoned"):
		attacker.handle_poisoned(self)
