extends Node2D


var money := 0 setget set_money
var money_increase := 5

func set_money(new_money):
	money = new_money
	$Gui.set_money(self.money)

func _on_Gui_dragging_started(texture):
	$Sprite.set_texture(texture)

func _process(_delta):
	$Sprite.position = get_global_mouse_position()

func _on_MoneyTimer_timeout():
	self.money += money_increase
