extends Node


func spawn_item(item):
	add_child(item)

func spawn_projectile(projectile):
	get_parent().get_node("Projectiles").spawn_projectile(projectile)
