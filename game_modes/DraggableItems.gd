extends Node


# IMPORTANT This may not be the best way to handle the items, maybe this should be it´s 
# own scene

func spawn_item(item):
	add_child(item)

func spawn_projectile(projectile):
	get_parent().get_node("Projectiles").spawn_projectile(projectile)

func on_Slingshot_selected(slingshot_id):
	for slingshot in get_tree().get_nodes_in_group("slingshots"):
		if slingshot.get_instance_id() != slingshot_id:
			slingshot.is_selected = false
