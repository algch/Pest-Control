extends Node2D


func _ready():
	randomize()

func _on_Gui_dragging_started(texture):
	$Sprite.set_texture(texture)

func _process(_delta):
	$Sprite.position = get_global_mouse_position()

func _on_Spawner_spawned(enemy):
	$Enemies.add_child(enemy)
