extends Node2D


var slingshot_class = preload("res://dragable_items/slingshot/Slingshot.tscn")
var poison_class = preload("res://dragable_items/poison/Poison.tscn")
var ant_class = preload("res://dragable_items/ant/Ant.tscn")

func _on_Gui_item_dragged(item_name: String, pos: Vector2):
	if not is_in_draggable_area(pos):
		return

	match item_name:
		"slingshot":
			var slingshot = slingshot_class.instance()
			slingshot.init(pos)
			slingshot.connect("selected", self, "on_Slingshot_selected")
			slingshot.connect("shoot", self, "on_Slingshot_shoot")
			spawn_item(slingshot)
		"poison":
			var poison = poison_class.instance()
			poison.init(pos)
			spawn_item(poison)
		"ant":
			var ant = ant_class.instance()
			ant.init(pos)
			spawn_item(ant)

func is_in_draggable_area(pos: Vector2):
	var inside_x = pos.x >= self.global_position.x and pos.x < $DraggableArea.global_position.x
	var inside_y = pos.y >= self.global_position.y and pos.y < $DraggableArea.global_position.y
	return inside_x and inside_y

func spawn_item(item):
	$Items.add_child(item)

func on_Slingshot_selected(slingshot_id):
	for slingshot in get_tree().get_nodes_in_group("slingshots"):
		if slingshot.get_instance_id() != slingshot_id:
			slingshot.is_selected = false

func on_Slingshot_shoot(projectile):
	$Projectiles.add_child(projectile)
