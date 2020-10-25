extends Frog


# ranged combat

var damage = 0.25
var poison_time = 3.0

func _ready():
    self.shoot_range = 600

func _on_SelectorButton_released():
	shoot_projectile()
	self.current_state = STATE.IDLE

func _process(_delta):
	if self.current_state != STATE.AIMING:
		return
	$Sprite.rotation = (reference_pos - get_global_mouse_position()).angle()

func shoot_projectile():
	if not self.can_shoot:
		return

	var raw_direction = reference_pos - get_global_mouse_position()
	if not raw_direction or not _is_aiming_angle_valid(raw_direction):
		return

	if raw_direction.length() <= self.action_thereshold:
		return

	var projectile = projectile_class.instance()
	projectile.init(self.position, raw_direction.normalized(), self.shoot_range, self.damage, true, self.poison_time)
	emit_signal("shoot", projectile)

	self.current_state = STATE.IDLE
	self.can_shoot = false
	start_cooldown()


