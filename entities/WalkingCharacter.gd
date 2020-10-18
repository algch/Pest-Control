extends KinematicBody2D

enum STATE {
	ADVANCE,
	APPROACH,
	ATTACK,
	KNOCKBACK,
	STAGGER,
}

const HALF_PI = PI / 2

var initial_rotation_delta = deg2rad(1)
var rotation_delta = initial_rotation_delta
var rotation_extents = deg2rad(22.5)
var initial_speed = 50.0
var speed = initial_speed
var knockback_speed = 600.0
var knockback_time = 0.2
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
var is_poisoned = false


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

	var text = ""
	match new_state:
		STATE.ADVANCE:
			$AnimatedSprite.play("walk")
			text = "ADVANCE"
		STATE.KNOCKBACK: 
			self.kb_timer.set_wait_time(knockback_time)
			self.kb_timer.start()
			$AnimatedSprite.stop()
			text = "KNOCKBACK"
		STATE.STAGGER:
			self.kb_timer.set_wait_time(stagger_time)
			self.kb_timer.start()
			$AnimatedSprite.stop()
			text = "STAGGER"
		STATE.ATTACK:
			$AnimatedSprite.play("attack")
			$AttackTimer.start()
			text = "ATTACK"
		STATE.APPROACH:
			$AnimatedSprite.play("walk")
			text = "APPROACH"

	$Label.set_text(text)
	current_state = new_state

func _on_kb_timer_timeout():
	self.kb_timer.stop()

	match current_state:
		STATE.KNOCKBACK:
			self.current_state = STATE.STAGGER
		STATE.STAGGER:
			self.current_state = STATE.APPROACH

func _physics_process(delta):
	match current_state:
		STATE.ADVANCE:
			do_advance(delta)
		STATE.KNOCKBACK:
			do_knockback()
		STATE.STAGGER:
			pass
		STATE.ATTACK:
			pass
		STATE.APPROACH:
			do_approach(delta)

func do_approach(delta):
	if not self.current_objective or not is_instance_valid(current_objective):
		self.current_state = STATE.ADVANCE
		self.current_objective = null
		return
	
	var dir_to_objective = self.current_objective.global_position - self.global_position
	var distance_to_objective = dir_to_objective.length()
	var min_attack_dist = $CollisionShape2D.shape.radius + self.current_objective.get_node("CollisionShape2D").shape.radius + 10
	if distance_to_objective <= min_attack_dist and $AttackArea.overlaps_body(self.current_objective):
		self.current_state = STATE.ATTACK
		return

	var dir_angle = self.direction.angle()
	var dir_to_objective_angle = dir_to_objective.angle()
	if dir_angle <= dir_to_objective_angle:
		self.direction = self.direction.rotated(abs(rotation_delta))
	else:
		self.direction = self.direction.rotated(-abs(rotation_delta))
	
	self.rotation = self.direction.angle()
	var motion = self.direction * self.speed * delta
	move_and_collide(motion)
	
func do_advance(delta):
	var init_dir_angle = self.initial_direction.angle()
	var dir_angle = self.direction.angle()
	var facing_north = dir_angle < 0
	if facing_north:
		self.rotation_delta = abs(self.rotation_delta)
		if dir_angle <= -HALF_PI:
			self.rotation_delta *= -1
	else:
		if dir_angle >= init_dir_angle + rotation_extents:
			self.rotation_delta = -abs(rotation_delta)
		elif dir_angle <= init_dir_angle - rotation_extents:
			self.rotation_delta = abs(rotation_delta)

	self.direction = self.direction.rotated(self.rotation_delta)
	self.rotation = self.direction.angle()
	var motion = direction * speed * delta
	if self.is_poisoned:
		motion /= 2
	var _collision = move_and_collide(motion)

func do_knockback():
	var motion = self.kb_dir * self.knockback_speed
	var _status = move_and_slide(motion)

func handle_melee_attack(attacker):
	if attacker.team == self.team:
		return

	self.health -= attacker.melee_damage
