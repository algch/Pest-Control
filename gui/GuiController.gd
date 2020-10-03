extends Control


var poison_sprite = load("res://draggable_items/poison/sprites/poison.png")
var slingshot_sprite = load("res://draggable_items/slingshot/sprites/slingshot.png")
var ant_sprite = load("res://draggable_items/ant/sprites/ant.png")

var is_dragging = false
var drag_item_name = ""
var drag_item_texture = null

onready var Gui = get_parent()

func _ready():
	pass # Replace with function body.

func _on_PoisonButton_button_down():
	is_dragging = true
	drag_item_name = "poison"
	Gui.item_dragging_started(poison_sprite)

func _on_SlingshotButton_button_down():
	is_dragging = true
	drag_item_name = "slingshot"
	Gui.item_dragging_started(slingshot_sprite)

func _on_AntButton_button_down():
	is_dragging = true
	drag_item_name = "ant"
	Gui.item_dragging_started(ant_sprite)

func _clear_state():
	is_dragging = false
	var mouse_pos = get_global_mouse_position()
	Gui.drag_item(drag_item_name, mouse_pos)
	Gui.item_dragging_started(null)
