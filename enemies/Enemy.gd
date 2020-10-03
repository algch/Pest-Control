extends "res://entities/WalkingCharacter.gd"

var poisoned_timer = Timer.new()
var poison_charges = 0
var poison_damage = 0


func _ready():
	initial_direction = Vector2.DOWN
	team = "ENEMY"
	add_child(poisoned_timer)
	poisoned_timer.connect("timeout", self, "_on_poisoned_timer_timeout")
	._ready()

func _on_poisoned_timer_timeout():
	if not poison_charges:
		poisoned_timer.stop()
		return

	self.health -= self.poison_damage
	self.poison_charges -= 1
	poisoned_timer.start()

func handle_poisoned(poisoner):
	self.poison_charges = poisoner.charges
	self.poison_damage = poisoner.poison_damage
	self.poisoned_timer.set_wait_time(poisoner.poison_time)
	self.poisoned_timer.start()
