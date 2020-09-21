extends StaticBody2D

var projectile_class = preload("./Projectile.tscn")
var is_selected := false setget set_is_selected
# listeing for input state may be better, use states instead
var reference_pos := Vector2()

func init(pos):
	position = pos

func set_is_selected(val):
	is_selected = val
	print("setter called")
	$Control/Label.visible = is_selected

func _unhandled_input(event):
	if not is_selected:
		return

	if event.is_action_pressed("touch"):
		reference_pos = get_global_mouse_position()

	if event.is_action_released("touch"):
		var raw_direction = reference_pos - get_global_mouse_position()
		# not a real solution, prevent _unhandled_input from called when pressing SelectorButton
		if raw_direction.length() <= 100:
			return
		var noramlized_direction = raw_direction.normalized()
		reference_pos = Vector2()
		var projectile = projectile_class.instance()
		projectile.init(position, noramlized_direction)
		get_parent().spawn_projectile(projectile)

func _on_SelectorButton_released():
	self.is_selected = not is_selected
