extends Node2D


var steps := []
var hide_text_timer = Timer.new()

class Step:
	var text
	var time # set to -1 will make it wait until advance_step()

	func _init(_text, _time):
		self.text = _text
		self.time = _time

func _ready():
	self.steps = [
		Step.new("Drag the eggs from the bottom of the screen to place them in the grid", -1),
		Step.new("Wait until the egg is ready", 5),
	]
	hide_text_timer.one_shot = true
	hide_text_timer.connect("timeout", self, "_on_hide_text_timer_timeout")
	add_child(hide_text_timer)
	advance_step()

func _on_Gui_dragging_started(texture):
	$Sprite.set_texture(texture)

func _process(_delta):
	$Sprite.position = get_global_mouse_position()

func _on_Spawner_spawned(enemy):
	$Enemies.add_child(enemy)

func _on_CheckEnemiesTimer_timeout():
	var enemies = len(get_tree().get_nodes_in_group("enemies"))
	if not enemies:
		$Spawner.start_wave($Spawner.current_wave + 1)

func advance_step():
	var next_step = steps.pop_front()
	print(next_step)
	if not next_step:
		get_tree().change_scene("res://gui/MainMenu.tscn")
	else:
		$TutorialLayer/VBoxContainer.set_visible(false)
		display_step(next_step)

func display_step(step: Step):
	$TutorialLayer/VBoxContainer.set_visible(true)
	$TutorialLayer/VBoxContainer/Label.set_text(step.text)

	if step.time > 0:
		hide_text_timer.set_wait_time(step.time)
		hide_text_timer.start()

func _on_hide_text_timer_timeout():
	advance_step()

func _on_Next_pressed():
	advance_step()
