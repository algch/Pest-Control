extends StaticBody2D


signal destroyed(cell_index)

var projectile_class = preload("./Projectile.tscn")
# listeing for input state may be better, use states instead
var reference_pos := Vector2()
var team = "PLAYER"
var max_health = 3.0
var health = max_health setget set_health
var cost = 0
var current_cell = null
var can_shoot = true
var shoot_range = 220.0
var action_thereshold = 10.0

class_name Frog

enum STATE {
	IDLE,
	AIMING,
}

var current_state = STATE.IDLE setget set_current_state

signal shoot(projectile)

func set_current_state(new_state):
	current_state = new_state

	match current_state:
		STATE.IDLE:
			self.reference_pos = Vector2()
		STATE.AIMING:
			self.reference_pos = get_global_mouse_position()
			# if self.reference_pos.distance_to(self.global_position) <= $SelectorButton.shape.radius:
			# 	current_state = STATE.IDLE
			# 	self.reference_pos = Vector2()

func set_health(new_health):
	if new_health <= 0:
		emit_signal("destroyed", current_cell)
		queue_free()

	health = new_health
	$HealthBar.value = (self.health / self.max_health) * $HealthBar.max_value

func shoot_projectile():
	if not self.can_shoot:
		return

	var raw_direction = reference_pos - get_global_mouse_position()
	if not raw_direction or not _is_aiming_angle_valid(raw_direction):
		return

	if raw_direction.length() <= self.action_thereshold:
		return

	var projectile = projectile_class.instance()
	projectile.init(position, raw_direction.normalized(), shoot_range)
	emit_signal("shoot", projectile)

	self.current_state = STATE.IDLE
	self.can_shoot = false
	start_cooldown()

func start_cooldown() -> void:
	$CooldownBar.visible = true
	$CooldownTimer.start()
	$Tween.interpolate_property($CooldownBar, "value", $CooldownBar.min_value, $CooldownBar.max_value, $CooldownTimer.wait_time)
	$Tween.start()

func _on_CooldownTimer_timeout():
	$CooldownTimer.stop()
	$CooldownBar.visible = false
	self.can_shoot = true

func _on_SelectorButton_pressed():
	self.current_state = STATE.AIMING
	emit_signal("selected", get_instance_id())

func _on_SelectorButton_released():
	# if not self.reference_pos != Vector2():
	# 	return
	shoot_projectile()
	self.current_state = STATE.IDLE

func handle_melee_attack(attacker):
	if attacker.team == self.team:
		return

	self.health -= attacker.melee_damage

func _process(_delta):
	update()

func _draw():
	if self.current_state != STATE.AIMING:
		return

	var raw_direction = reference_pos - get_global_mouse_position()
	if not raw_direction:
		raw_direction = Vector2.UP

	var color = Color(1, 1, 1)
	if not _is_aiming_angle_valid(raw_direction) or not self.can_shoot:
		color = Color(1, 0, 0)
	var up = Vector2.UP.angle()
	var offset = deg2rad(45)
	draw_arc(Vector2(), self.shoot_range, up - offset, up + offset, 50, color, 5)
	draw_line(Vector2(), raw_direction.normalized() * self.shoot_range, color, 5)
	draw_circle(reference_pos - self.position, get_global_mouse_position().distance_to(reference_pos), color - Color(0, 0, 0, 0.8))

func _is_aiming_angle_valid(dir : Vector2) -> bool:
	var aiming_angle = rad2deg(dir.angle_to(Vector2.UP))
	if not (aiming_angle >= -45 and aiming_angle <= 45):
		return false
	return true
