extends Node2D


func _ready():
	randomize()

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
