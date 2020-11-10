extends CanvasLayer


signal dragging_started(texture)

signal item_dragged(item_name, pos)

func _ready():
	var egg_progress = $GuiController/HBoxContainer/EggProgress
	$Tween.interpolate_property(egg_progress, "value", egg_progress.min_value, egg_progress.max_value, 10)
	$Tween.start()

func drag_item(item_name, pos):
	emit_signal("item_dragged", item_name, pos)

func item_dragging_started(texture):
	emit_signal("dragging_started", texture)

func _on_ItemHandler_eggs_changed(new_eggs):
	$GuiController/HBoxContainer/LabelEggs.set_text(str(new_eggs))

func _on_ItemHandler_frogs_changed():
	var all_males = get_tree().get_nodes_in_group("males")
	var male_frogs = 0
	for frog in all_males:
		if is_instance_valid(frog) and frog.health > 0:
			male_frogs += 1

	var all_females = get_tree().get_nodes_in_group("females")
	var female_frogs = 0
	for frog in all_females:
		if is_instance_valid(frog) and frog.health > 0:
			female_frogs += 1

	var increase = min(male_frogs, female_frogs)

	$GuiController/HBoxContainer/LabelMales.set_text("x" + str(male_frogs))
	$GuiController/HBoxContainer/LabelFemales.set_text("x" + str(female_frogs))
	$GuiController/HBoxContainer/LabelIncrease.set_text("=" + str(increase))

func display_game_over():
	$GuiController/VBoxContainer.set_visible(true)

func _on_BackButton_pressed():
	var tree = get_tree()
	tree.set_pause(false)
	tree.change_scene("res://gui/MainMenu.tscn")
