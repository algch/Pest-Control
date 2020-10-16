extends Frog


# ranged combat

var damage = 0

func _ready():
    self.shoot_range = 600
    $Sprite.modulate = Color(0.5, 0, 0, 0.5)

func _on_SelectorButton_released():
	shoot_projectile()
	self.current_state = STATE.IDLE

func shoot_projectile():
	if not self.can_shoot:
		return

	var raw_direction = reference_pos - get_global_mouse_position()
	if not raw_direction or not _is_aiming_angle_valid(raw_direction):
		return

	if raw_direction.length() <= self.action_thereshold:
		return

	var projectile = projectile_class.instance()
	projectile.init(self.position, raw_direction.normalized(), self.shoot_range, self.damage)
	emit_signal("shoot", projectile)

	self.current_state = STATE.IDLE
	self.can_shoot = false
	$PunchSound.play()
	start_cooldown()


