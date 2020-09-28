extends StaticBody2D


func init(pos):
	self.position = pos

func handle_melee_attack(attacker):
	if is_instance_valid(attacker) and attacker.has_method("handle_poisoned"):
		attacker.handle_poisoned(self)
	queue_free()
