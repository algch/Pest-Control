extends StaticBody2D


signal destroyed(cell_index)
signal hatch(type, pos)

var team = "PLAYER"
var max_health = 3.0
var health = max_health setget set_health
var cost = 1
var current_cell = null
var is_ready = false

class_name Egg

func set_health(new_health):
	if new_health <= 0:
		emit_signal("destroyed", current_cell)
		queue_free()

	health = new_health
	$HealthBar.value = (self.health / self.max_health) * $HealthBar.max_value

func _ready():
	$Tween.interpolate_property($GrowthBar, "value", $GrowthBar.min_value, $GrowthBar.max_value, $GrowthTimer.wait_time)
	$Tween.start()

func _on_GrowthTimer_timeout():
	$GrowthTimer.stop()
	$GrowthBar.visible = false
	self.is_ready = true

func _on_MenuButton_pressed():
	if not self.is_ready:
		return

	$Menu.visible = true

func _on_MenuButton_released():
	if not self.is_ready:
		return

	$Menu.visible = false
	var option = get_selected_option()
	match option:
		"frog":
			self.health = 0
			emit_signal("hatch", "frog", self.position)

func get_selected_option():
	var mouse_pos = get_local_mouse_position()
	var options = $Menu.get_children()
	for option in options:
		var rect = option.get_rect()
		var point = mouse_pos - option.position
		if rect.has_point(point):
			return option.name

	return null

func handle_melee_attack(attacker):
	if attacker.team == self.team:
		return

	self.health -= attacker.melee_damage
