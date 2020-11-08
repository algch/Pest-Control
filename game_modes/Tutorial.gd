extends Node2D


var egg_selected_texture = preload("res://gui/sprites/egg_focused.png")
var egg_deselected_texture = preload("res://gui/sprites/egg.png")

var steps := []
var hide_text_timer = Timer.new()
var current_step = null
var steps_stopped = false

class Step:
	var text
	var time # set to -1 will make it wait until advance_step()
	var func_call
	var node_path
	var advance_on_next

	func _init(_text, _time, _func_call=null, _node_path=null, _advance_on_next=true):
		self.text = _text
		self.time = _time
		self.func_call = _func_call
		self.node_path = _node_path
		self.advance_on_next = _advance_on_next

func _ready():
	self.steps = [
		Step.new("Drag the eggs from the bottom of the screen to place them in the grid", 5, "set_egg_selected", ".", false),
		Step.new(null, 5, "set_egg_deselected", ".", false),
		Step.new("When the egg is ready, you'll be able to select turning it into male or female by pressing and dragging to an option", -1),
		Step.new("A female and a male will produce a new egg each time the bar in the bottom fills", -1),
		Step.new("Males have a short range and cause damage, females are long ranged and poison the spiders", -1),
		Step.new("Be careful, frogs degrade and die as time passes", -1),
		Step.new(null, 5),
		Step.new("There comes a spider! press and drag a frog to attack it. ", 5, "spawn_spider", "."),
		Step.new(null, 10, "set_egg_deselected", ".", false),
		Step.new("Press Ok to return to the main menu", -1),
		Step.new(null, -1, "return_to_menu", "."),
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

func advance_step():
	if steps_stopped:
		return

	self.current_step = steps.pop_front()
	print(self.current_step)
	if not self.current_step:
		return

	$TutorialLayer/VBoxContainer.set_visible(false)
	display_step(self.current_step)
	if self.current_step.func_call and self.current_step.node_path:
		get_node(self.current_step.node_path).call(self.current_step.func_call)

func display_step(step: Step):
	if step.text:
		$TutorialLayer/VBoxContainer.set_visible(true)
		$TutorialLayer/VBoxContainer/Label.set_text(step.text)

	if step.time > 0:
		hide_text_timer.set_wait_time(step.time)
		hide_text_timer.start()

func _on_hide_text_timer_timeout():
	advance_step()

func _on_Next_pressed():
	if self.current_step.advance_on_next:
		advance_step()
	else:
		$TutorialLayer/VBoxContainer.set_visible(false)

func set_egg_selected():
	$Gui/GuiController/HBoxContainer/EggButton.set_normal_texture(egg_selected_texture)

func set_egg_deselected():
	$Gui/GuiController/HBoxContainer/EggButton.set_normal_texture(egg_deselected_texture)

func return_to_menu():
	get_tree().change_scene("res://gui/MainMenu.tscn")

func spawn_spider():
	$TutorialSpawner.spawn_spider()
