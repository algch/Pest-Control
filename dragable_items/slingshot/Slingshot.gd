extends StaticBody2D

var projectile_class = preload("./Projectile.tscn")
var is_selected := false setget set_is_selected
# listeing for input state may be better, use states instead
var reference_pos := Vector2()

signal selected(selected_id)
signal shoot(projectile)

func set_is_selected(val):
	is_selected = val
	print("setter called")
	$Control/Label.visible = is_selected

func _unhandled_input(event):
	if not is_selected:
		return

	if event.is_action_pressed("touch"):
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.distance_to(self.position) <= $SelectorButton.shape.radius:
			self.reference_pos = Vector2()
			return
		self.reference_pos = mouse_pos

	if event.is_action_released("touch") and self.reference_pos != Vector2():
		var raw_direction = reference_pos - get_global_mouse_position()
		var noramlized_direction = raw_direction.normalized()
		reference_pos = Vector2()
		var projectile = projectile_class.instance()
		projectile.init(position, noramlized_direction)
		emit_signal("shoot", projectile)

func _on_SelectorButton_released():
	self.is_selected = not is_selected
	if is_selected:
		emit_signal("selected", get_instance_id())
