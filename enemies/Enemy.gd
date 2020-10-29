extends "res://entities/WalkingCharacter.gd"

var poison_damage := 0.0
var poison_time := 0.0
var wave


class_name Enemy


func _ready():
	initial_direction = Vector2.DOWN
	team = "ENEMY"
	add_to_group("enemies")
	._ready()

func _on_PoisonedTimer_timeout():
	self.poison_time -= $PoisonedTimer.wait_time
	if self.poison_time <= 0:
		self.is_poisoned = false
		self.speed = self.initial_speed
		self.rotation_delta = self.initial_rotation_delta
		$PoisonedTimer.stop()
		return

	self.health -= self.poison_damage
	$PoisonedTimer.start()

# handle multiple ???
func handle_poisoned(pois_dam, pois_time):
	self.poison_damage = pois_dam
	self.poison_time += pois_time
	$PoisonedTimer.start()
	self.speed /= 2
	self.rotation_delta /= 2
	self.is_poisoned = true

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

func handle_projectile_collision(projectile, collision):
	self.kb_dir = projectile.direction.bounce(collision.normal)
	self.current_state = STATE.KNOCKBACK
	self.health -= projectile.damage
	projectile.queue_free()
