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

func _on_DetectionArea_body_entered(body):
	if not body.has_method("handle_melee_attack"):
		return
	if body.team == self.team:
		return
	if self.current_objective and is_instance_valid(self.current_objective):
		return

	self.current_objective = body
	self.current_state = STATE.APPROACH

func _on_AttackTimer_timeout():
	if not self.current_objective or not is_instance_valid(self.current_objective):
		$AttackTimer.stop()
		self.current_state = STATE.ADVANCE
		self.current_objective = null
		return

	if not $AttackArea.overlaps_body(self.current_objective):
		$AttackTimer.stop()
		self.current_state = STATE.APPROACH
		return
	
	self.current_objective.handle_melee_attack(self)

	if not is_instance_valid(self.current_objective) or self.current_objective.health <= 0:
		$AttackTimer.stop()
		self.current_state = STATE.ADVANCE
		self.current_objective = null
		return

	$AttackTimer.start()
	$AnimatedSprite.play("attack")
