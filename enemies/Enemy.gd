extends KinematicBody2D

enum STATE {
	ADVANCE,
	ATTACK,
	STAGGER,
}
var rotation_delta = deg2rad(1)
var direction = Vector2.DOWN
var speed = 50.0

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if rad2deg(direction.angle()) <= 45 or rad2deg(direction.angle()) >= 135:
		rotation_delta *= -1
	direction = direction.rotated(rotation_delta)
	rotation = direction.angle()
	var motion = direction * speed * delta
	var collision = move_and_collide(motion)
