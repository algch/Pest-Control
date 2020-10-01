extends Node2D


var slingshot_class = preload("res://dragable_items/slingshot/Slingshot.tscn")
var poison_class = preload("res://dragable_items/poison/Poison.tscn")
var ant_class = preload("res://dragable_items/ant/Ant.tscn")

var horizontal_slots = 6
var vertical_slots = 5
onready var h_slot_size = $DraggableArea.position.x / self.horizontal_slots
onready var v_slot_size = $DraggableArea.position.y / self.vertical_slots

var cells := []

class Cell:
	var top_left : Vector2
	var bottom_right : Vector2

	func _init(_top_left : Vector2, _bottom_right :Vector2):
		self.top_left = _top_left
		self.bottom_right = _bottom_right

	func is_inside(pos : Vector2):
		var is_inside_x = self.top_left.x <= pos.x and self.bottom_right.x >= pos.x
		var is_inside_y = self.top_left.y <= pos.y and self.bottom_right.y >= pos.y
		return is_inside_x and is_inside_y

	func get_center_position():
		return self.top_left + (self.bottom_right - self.top_left) / 2

func _find_cell(pos : Vector2):
	for cell in cells:
		if cell.is_inside(pos):
			return cell

func _on_Gui_item_dragged(item_name: String, pos: Vector2):
	if not is_in_draggable_area(pos):
		return

	match item_name:
		"slingshot":
			var slingshot = slingshot_class.instance()
			slingshot.connect("selected", self, "on_Slingshot_selected")
			slingshot.connect("shoot", self, "on_Slingshot_shoot")
			spawn_item(slingshot, pos)
		"poison":
			var poison = poison_class.instance()
			spawn_item(poison, pos)
		"ant":
			var ant = ant_class.instance()
			spawn_item(ant, pos)

func is_in_draggable_area(pos: Vector2):
	var inside_x = pos.x >= self.global_position.x and pos.x < $DraggableArea.global_position.x
	var inside_y = pos.y >= self.global_position.y and pos.y < $DraggableArea.global_position.y
	return inside_x and inside_y

func spawn_item(item, mouse_pos):
	var local_mouse_pos = mouse_pos - self.position
	var found_cell = self._find_cell(local_mouse_pos)
	if found_cell:
		var item_pos = found_cell.get_center_position() + self.position
		item.position = item_pos
		$Items.add_child(item)

func on_Slingshot_selected(slingshot_id):
	for slingshot in get_tree().get_nodes_in_group("slingshots"):
		if slingshot.get_instance_id() != slingshot_id:
			slingshot.is_selected = false

func on_Slingshot_shoot(projectile):
	$Projectiles.add_child(projectile)

func _ready():
	var local_x = 0.0
	var local_y = 0.0
	var size = Vector2(h_slot_size, v_slot_size)
	for _i in range(horizontal_slots):
		local_y = 0
		for _j in range(vertical_slots):
			var from = Vector2(local_x, local_y)
			var to = from + size
			var new_cell = Cell.new(from, to)
			self.cells.append(new_cell)
			local_y += self.v_slot_size
		local_x += self.h_slot_size

func _draw():
	var local_color = Color(0, 0, 0.5)
	for cell in cells:
		draw_rect(
			Rect2(
				cell.top_left,
				cell.bottom_right - cell.top_left
			),
			local_color,
			false
		)
