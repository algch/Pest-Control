extends StaticBody2D

var projectile_class = preload("./Projectile.tscn")
var is_selected := false setget set_is_selected
# listeing for input state may be better, use states instead
var reference_pos := Vector2()
var team = "PLAYER"
var max_health = 3.0
var health = max_health setget set_health
var cost = 15

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
		queue_free()

	health = new_health
	$TextureProgress.value = (self.health / self.max_health) * $TextureProgress.max_value

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
	var raw_direction = reference_pos - get_global_mouse_position()
	if not raw_direction:
		raw_direction = Vector2.UP

	var projectile = projectile_class.instance()
	projectile.init(position, raw_direction.normalized())
	emit_signal("shoot", projectile)

	self.current_state = STATE.IDLE

func _on_SelectorButton_released():
	self.is_selected = not is_selected
	if is_selected:
		emit_signal("selected", get_instance_id())

func handle_melee_attack(attacker):
	if attacker.team == self.team:
		return

	self.health -= attacker.melee_damage
