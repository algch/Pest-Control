extends "res://entities/WalkingCharacter.gd"


signal updated_position(item)
signal destroyed(cell_index)

var cost = 50
var current_cell = null

class_name Ant

func _on_CellCheckTimer_timeout():
	emit_signal("updated_position", self)

func _ready():
	max_health = 3.0
	health = max_health
	melee_damage = 0.25
	initial_direction = Vector2.UP
	team = "PLAYER"
	connect("tree_exited", self, "_on_Ant_tree_exited")
	._ready()

func _on_Ant_tree_exited():
	emit_signal("destroyed", current_cell)