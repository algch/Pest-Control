extends CanvasLayer

signal item_dragged(item_name, pos)

func drag_item(item_name, pos):
	emit_signal("item_dragged", item_name, pos)
