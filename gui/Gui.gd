extends CanvasLayer


signal dragging_started(texture)

signal item_dragged(item_name, pos)

func set_money(money):
	$GuiController/HBoxContainer/Label.set_text(str(money))

func drag_item(item_name, pos):
	emit_signal("item_dragged", item_name, pos)

func item_dragging_started(texture):
	print("texture ", texture)
	emit_signal("dragging_started", texture)
