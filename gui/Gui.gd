extends CanvasLayer


signal dragging_started(texture)

signal item_dragged(item_name, pos)

func drag_item(item_name, pos):
	emit_signal("item_dragged", item_name, pos)

func item_dragging_started(texture):
	emit_signal("dragging_started", texture)

func _on_ItemHandler_money_changed(new_money):
	$GuiController/HBoxContainer/Label.set_text(str(new_money))
