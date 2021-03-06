extends Control


var poison_sprite = load("res://draggable_items/poison/sprites/poison.png")
var frog_sprite = load("res://draggable_items/frog/sprites/frog.png")
var egg_sprite = load("res://draggable_items/egg/sprites/egg.png")

var is_dragging = false
var drag_item_name = ""
var drag_item_texture = null

onready var Gui = get_parent()

func _ready():
	pass # Replace with function body.

func _on_EggButton_button_down():
	is_dragging = true
	drag_item_name = "egg"
	Gui.item_dragging_started(egg_sprite)

func _clear_state():
	is_dragging = false
	var mouse_pos = get_global_mouse_position()
	Gui.drag_item(drag_item_name, mouse_pos)
	Gui.item_dragging_started(null)
