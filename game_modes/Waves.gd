extends Node2D


func _on_Gui_dragging_started(texture):
	$Sprite.set_texture(texture)

func _process(_delta):
	$Sprite.position = get_global_mouse_position()

func _on_WaveSpawner_spawned(enemy):
	$Enemies.add_child(enemy)

func _on_CheckEnemiesTimer_timeout():
	var enemies = len(get_tree().get_nodes_in_group("enemies"))
	if not enemies:
		$WaveSpawner.start_wave($WaveSpawner.current_wave + 1)

func _on_GameOverLine_body_entered(body):
	$Gui.display_game_over()
	get_tree().set_pause(true)
