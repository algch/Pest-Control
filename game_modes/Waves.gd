extends Node


var slingshot_class = preload("res://dragable_items/slingshot/Slingshot.tscn")
var poison_class = preload("res://dragable_items/poison/Poison.tscn")
var ant_class = preload("res://dragable_items/ant/Ant.tscn")

func _on_Gui_item_draged(item_name: String, pos: Vector2):
	if not is_in_dragable_area(pos):
		return

	match item_name:
		"slingshot":
			var slingshot = slingshot_class.instance()
			slingshot.init(pos)
			$DraggableItems.spawn_item(slingshot)
		"poison":
			var poison = poison_class.instance()
			poison.init(pos)
			$DraggableItems.spawn_item(poison)
		"ant":
			var ant = ant_class.instance()
			ant.init(pos)
			$DraggableItems.spawn_item(ant)

func is_in_dragable_area(pos: Vector2):
	var inside_x = pos.x >= $DragableAreaTL.position.x and pos.x < $DragableAreaBR.position.x
	var inside_y = pos.y >= $DragableAreaTL.position.y and pos.y < $DragableAreaBR.position.y
	return inside_x and inside_y
