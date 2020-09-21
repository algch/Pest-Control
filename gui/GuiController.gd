extends Control


var is_dragging = false
var drag_item_name = ""

onready var Gui = get_parent()

func _ready():
	pass # Replace with function body.

func _on_PoisonButton_button_down():
	is_dragging = true
	drag_item_name = "poison"

func _on_SlingshotButton_button_down():
	is_dragging = true
	drag_item_name = "slingshot"

func _on_AntButton_button_down():
	is_dragging = true
	drag_item_name = "ant"

func _clear_state():
	is_dragging = false
	var mouse_pos = get_global_mouse_position()
	Gui.drag_item(drag_item_name, mouse_pos)
