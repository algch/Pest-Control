extends KinematicBody2D

enum STATE {
	ADVANCE,
	ATTACK,
	KNOCKBACK,
	STAGGER,
}

var rotation_delta = deg2rad(1)
var direction = Vector2.DOWN
var speed = 50.0
var knockback_speed = 600.0
var knockback_time = 0.1
var stagger_time = 1.0
var kb_timer = Timer.new()
var kb_dir = Vector2()
var current_state = STATE.ADVANCE setget set_current_state

func set_current_state(new_state):
	if current_state == new_state:
		return

	match new_state:
		STATE.ADVANCE:
			$AnimatedSprite.play()
		STATE.KNOCKBACK: 
			self.kb_timer.set_wait_time(knockback_time)
			self.kb_timer.start()
			$AnimatedSprite.stop()
		STATE.STAGGER:
			self.kb_timer.set_wait_time(stagger_time)
			self.kb_timer.start()
			$AnimatedSprite.stop()

	current_state = new_state

func _on_kb_timer_timeout():
	self.kb_timer.stop()

	match current_state:
		STATE.KNOCKBACK:
			self.current_state = STATE.STAGGER
		STATE.STAGGER:
			self.current_state = STATE.ADVANCE

func _ready():
	self.kb_timer.connect("timeout", self, "_on_kb_timer_timeout")
	add_child(kb_timer)

func _physics_process(delta):
	match current_state:
		STATE.ADVANCE:
			do_advance(delta)
		STATE.KNOCKBACK:
			do_knockback()
		STATE.STAGGER:
			pass

func do_advance(delta):
	if rad2deg(self.direction.angle()) <= 45 or rad2deg(self.direction.angle()) >= 135:
		rotation_delta *= -1
	self.direction = self.direction.rotated(rotation_delta)
	self.rotation = self.direction.angle()
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)

func do_knockback():
	var motion = self.kb_dir * self.knockback_speed
	move_and_slide(motion)

func handle_projectile_collision(projectile, collision):
	self.kb_dir = projectile.direction.bounce(collision.normal)
	self.current_state = STATE.KNOCKBACK
	projectile.queue_free()
