extends KinematicBody2D


var explosion_class = preload("res://draggable_items/slingshot/Explosion.tscn")

var direction = Vector2.UP
var speed = 500.0

signal exploded(explosion)

func init(pos: Vector2, dir: Vector2):
	position = pos
	direction = dir

func _physics_process(delta):
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)

	if collision:
		self.direction = self.direction.bounce(collision.normal)
		if collision.collider.has_method("handle_projectile_collision"):
			collision.collider.handle_projectile_collision(self, collision)

		destroy()

func destroy():
	var explosion = explosion_class.instance()
	explosion.global_position = self.global_position
	emit_signal("exploded", explosion)
	queue_free()
