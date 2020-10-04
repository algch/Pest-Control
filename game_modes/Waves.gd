extends Node2D


func _on_Gui_dragging_started(texture, cost):
	$Sprite.set_texture(texture)
	$Sprite/Label.set_text("-" + str(cost))
	$Sprite/Label.visible = true
	if cost == 0:
		$Sprite/Label.visible = false

func _process(_delta):
	$Sprite.position = get_global_mouse_position()

func _on_Spawner_spawned(enemy):
	$Enemies.add_child(enemy)
