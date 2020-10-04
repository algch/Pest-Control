extends StaticBody2D


signal destroyed(cell_index)

var projectile_class = preload("./Projectile.tscn")
var is_selected := false setget set_is_selected
# listeing for input state may be better, use states instead
var reference_pos := Vector2()
var team = "PLAYER"
var max_health = 3.0
var health = max_health setget set_health
var cost = 15
var current_cell = null
var can_shoot = true

class_name Slingshot

enum STATE {
	IDLE,
	AIMING,
}

var current_state = STATE.IDLE setget set_current_state

signal selected(selected_id)
signal shoot(projectile)

func set_current_state(new_state):
	current_state = new_state

	match current_state:
		STATE.IDLE:
			self.reference_pos = Vector2()
		STATE.AIMING:
			self.reference_pos = get_global_mouse_position()
			if self.reference_pos.distance_to(self.global_position) <= $SelectorButton.shape.radius:
				current_state = STATE.IDLE
				self.reference_pos = Vector2()

func set_health(new_health):
	if new_health <= 0:
		emit_signal("destroyed", current_cell)
		queue_free()

	health = new_health
	$HealthBar.value = (self.health / self.max_health) * $HealthBar.max_value

func set_is_selected(val):
	is_selected = val
	$Control/Label.visible = is_selected

func _unhandled_input(event):
	if not is_selected:
		return

	if event.is_action_pressed("touch"):
		self.current_state = STATE.AIMING

	if event.is_action_released("touch") and self.reference_pos != Vector2():
		shoot_projectile()
		self.current_state = STATE.IDLE

func shoot_projectile():
	if not self.can_shoot:
		return

	var raw_direction = reference_pos - get_global_mouse_position()
	if not raw_direction:
		raw_direction = Vector2.UP

	if not _is_aiming_angle_valid(raw_direction):
		return

	var projectile = projectile_class.instance()
	projectile.init(position, raw_direction.normalized())
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

func _on_SelectorButton_released():
	self.is_selected = not is_selected
	if is_selected:
		emit_signal("selected", get_instance_id())

func handle_melee_attack(attacker):
	if attacker.team == self.team:
		return

	self.health -= attacker.melee_damage

func _process(_delta):
	update()

func _draw():
	if not self.is_selected or self.current_state != STATE.AIMING:
		return

	var raw_direction = reference_pos - get_global_mouse_position()
	if not raw_direction:
		raw_direction = Vector2.UP

	var color = Color(1, 1, 1)
	if not _is_aiming_angle_valid(raw_direction) or not self.can_shoot:
		color += Color(0, -1, -1)
	draw_line(Vector2(), raw_direction.normalized() * 100, color)

func _is_aiming_angle_valid(dir : Vector2) -> bool:
	var aiming_angle = rad2deg(dir.angle_to(Vector2.UP))
	if not (aiming_angle >= -45 and aiming_angle <= 45):
		return false
	return true
