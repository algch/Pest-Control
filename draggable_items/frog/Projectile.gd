extends KinematicBody2D


var explosion_class = preload("res://draggable_items/frog/Explosion.tscn")

var direction = Vector2.UP
var speed = 1500.0
var distance_span
var damage : float
var is_poisonus : bool
var poison_time : float

signal exploded(explosion)

func init(pos: Vector2, dir: Vector2, dist_span: float, dam : float, pois : bool = false, pois_time : float = 0):
	self.position = pos
	self.direction = dir
	self.distance_span = dist_span
	self.damage = dam
	self.is_poisonus = pois
	self.poison_time = pois_time

func _physics_process(delta):
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)

	if collision:
		self.direction = self.direction.bounce(collision.normal)
		if collision.collider is Enemy:
			if self.is_poisonus:
				collision.collider.handle_poisoned(self.damage, self.poison_time)
			else:
				collision.collider.handle_projectile_collision(self, collision)

		destroy()

func _ready():
	var wait_time = distance_span / speed
	$Timer.set_wait_time(wait_time)
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	$Timer.start()
	$ParticlesTail.emitting = true

func _on_Timer_timeout():
	destroy()

func destroy():
	var explosion = explosion_class.instance()
	explosion.position = self.position
	emit_signal("exploded", explosion)
	queue_free()
