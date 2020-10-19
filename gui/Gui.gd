extends CanvasLayer


signal dragging_started(texture)

signal item_dragged(item_name, pos)

func drag_item(item_name, pos):
	emit_signal("item_dragged", item_name, pos)

func item_dragging_started(texture, cost):
	emit_signal("dragging_started", texture, cost)

func _on_ItemHandler_eggs_changed(new_eggs):
	$GuiController/HBoxContainer/Label.set_text(str(new_eggs))
