extends KinematicBody2D

enum STATE {
	ADVANCE,
	ATTACK,
	KNOCKBACK,
	STAGGER,
}

var rotation_delta = deg2rad(1)
var rotation_extents = deg2rad(22.5)
var speed = 50.0
var knockback_speed = 600.0
var knockback_time = 0.1
var stagger_time = 0.3
var kb_timer = Timer.new()
var kb_dir = Vector2()
var current_state = STATE.ADVANCE setget set_current_state
var current_objective = null

# must be set in inherited script
var direction = Vector2()
var initial_direction = Vector2()
var max_health = null
var health = null setget set_health
var melee_damage = null
var team = null


func _ready():
	self.direction = self.initial_direction
	self.kb_timer.connect("timeout", self, "_on_kb_timer_timeout")
	add_child(kb_timer)

func set_health(new_health):
	if new_health <= 0:
		queue_free()

	health = new_health
	$TextureProgress.value = (self.health / self.max_health) * $TextureProgress.max_value

func set_current_state(new_state):
	if current_state == new_state:
		return

	match new_state:
		STATE.ADVANCE:
			$AnimatedSprite.play("walk")
			$ObjectiveCheckTimer.start()
		STATE.KNOCKBACK: 
			self.kb_timer.set_wait_time(knockback_time)
			self.kb_timer.start()
			$AnimatedSprite.stop()
		STATE.STAGGER:
			self.kb_timer.set_wait_time(stagger_time)
			self.kb_timer.start()
			$AnimatedSprite.stop()
		STATE.ATTACK:
			$AnimatedSprite.play("attack")
			$AttackTimer.start()

	current_state = new_state

func _on_AttackTimer_timeout():
	if not is_instance_valid(self.current_objective):
		$AttackTimer.stop()
		return
	
	self.current_objective.handle_melee_attack(self)
	$AttackTimer.start()
	$AnimatedSprite.play("attack")

func _on_kb_timer_timeout():
	self.kb_timer.stop()

	match current_state:
		STATE.KNOCKBACK:
			self.current_state = STATE.STAGGER
		STATE.STAGGER:
			self.current_state = STATE.ADVANCE

func _physics_process(delta):
	match current_state:
		STATE.ADVANCE:
			do_advance(delta)
		STATE.KNOCKBACK:
			do_knockback()
		STATE.STAGGER:
			pass
		STATE.ATTACK:
			do_check_objective()

func do_advance(delta):
	var init_dir_angle = self.initial_direction.angle()
	var dir_angle = self.direction.angle()
	if dir_angle <= init_dir_angle - rotation_extents or dir_angle >= init_dir_angle + rotation_extents:
		self.rotation_delta *= -1
	self.direction = self.direction.rotated(rotation_delta)
	self.rotation = self.direction.angle()
	var motion = direction * speed * delta
	var _collision = move_and_collide(motion)

func do_knockback():
	var motion = self.kb_dir * self.knockback_speed
	var _status = move_and_slide(motion)

func do_check_objective():
	var collider = $ObjectiveChecker.get_collider()
	if not is_instance_valid(self.current_objective) or collider != self.current_objective:
		self.current_objective = null
		$AttackTimer.stop()
		self.current_state = STATE.ADVANCE

func handle_projectile_collision(projectile, collision):
	self.kb_dir = projectile.direction.bounce(collision.normal)
	self.current_state = STATE.KNOCKBACK
	self.health -= 1
	projectile.queue_free()

func handle_melee_attack(attacker):
	if attacker.team == self.team:
		return

	self.health -= attacker.melee_damage

func _on_ObjectiveCheckTimer_timeout():
	var collider = $ObjectiveChecker.get_collider()
	if not collider:
		return
	if not collider.has_method("handle_melee_attack"):
		return
	if collider.team == self.team:
		return

	self.current_objective = collider
	self.current_state = STATE.ATTACK
	$ObjectiveCheckTimer.stop()
