extends Control


func _ready():
	randomize()

func _on_Play_pressed():
	var scene_opened = get_tree().change_scene("res://game_modes/Waves.tscn")

func _on_Tutorial_pressed():
	var scene_opened = get_tree().change_scene("res://game_modes/Tutorial.tscn")

func _on_Quit_pressed():
	get_tree().quit()
