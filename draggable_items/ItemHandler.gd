extends Node2D


signal money_changed(value)

var frog_class = preload("res://draggable_items/frog/Frog.tscn")
var poison_class = preload("res://draggable_items/poison/Poison.tscn")
var ant_class = preload("res://draggable_items/ant/Ant.tscn")
var egg_class = preload("res://draggable_items/egg/Egg.tscn")

var horizontal_slots = 3
var vertical_slots = 4
onready var h_slot_size = $DraggableArea.position.x / self.horizontal_slots
onready var v_slot_size = $DraggableArea.position.y / self.vertical_slots
var money = 100 setget set_money
var money_increase := 5

var cells := []

class Cell:
	var top_left : Vector2
	var bottom_right : Vector2
	var is_free := true
	var index : int

	func _init(_top_left : Vector2, _bottom_right :Vector2, _index : int):
		self.top_left = _top_left
		self.bottom_right = _bottom_right
		self.index = _index

	func is_inside(pos : Vector2):
		var is_inside_x = self.top_left.x <= pos.x and self.bottom_right.x >= pos.x
		var is_inside_y = self.top_left.y <= pos.y and self.bottom_right.y >= pos.y
		return is_inside_x and is_inside_y

	func get_center_position():
		return self.top_left + (self.bottom_right - self.top_left) / 2

func set_money(new_money):
	money = new_money
	emit_signal("money_changed", self.money)

func _on_MoneyTimer_timeout():
	self.money += money_increase

func _find_cell(pos : Vector2):
	for cell in cells:
		if cell.is_inside(pos):
			return cell

func _on_Gui_item_dragged(item_name: String, pos: Vector2):
	if not is_in_draggable_area(pos):
		return

	var item = instance_item_by_name(item_name)
	spawn_item(item, pos)

func instance_item_by_name(item_name):
	match item_name:
		"frog":
			var frog = frog_class.instance()
			frog.connect("shoot", self, "on_Frog_shoot")
			frog.connect("destroyed", self, "_on_item_destroyed")
			return frog
		"poison":
			var poison = poison_class.instance()
			poison.connect("destroyed", self, "_on_item_destroyed")
			return poison
		"ant":
			var ant = ant_class.instance()
			ant.connect("updated_position", self, "_on_item_updated_position")
			ant.connect("destroyed", self, "_on_item_destroyed")
			return ant
		"egg":
			var egg = egg_class.instance()
			egg.connect("destroyed", self, "_on_item_destroyed")
			egg.connect("hatch", self, "_on_Egg_hatched")
			return egg
	return null

func _on_Egg_hatched(type, pos):
	var item = instance_item_by_name(type)
	spawn_item(item, pos)

func _on_item_destroyed(cell_index):
	if not cell_index:
		return

	var current_cell = cells[cell_index]
	current_cell.is_free = true

func _on_item_updated_position(item):
	if not item.current_cell:
		return

	var local_pos = item.global_position - self.position
	var found_cell = _find_cell(local_pos)
	var current_cell = cells[item.current_cell]
	if not found_cell:
		current_cell.is_free = true
		item.current_cell = null
		return

	if current_cell != found_cell:
		current_cell.is_free = true
		found_cell.is_free = false
		item.current_cell = found_cell.index

func is_in_draggable_area(pos: Vector2):
	var inside_x = pos.x >= self.global_position.x and pos.x < $DraggableArea.global_position.x
	var inside_y = pos.y >= self.global_position.y and pos.y < $DraggableArea.global_position.y
	return inside_x and inside_y

func spawn_item(item, mouse_pos):

	var local_mouse_pos = mouse_pos - self.position
	var found_cell = self._find_cell(local_mouse_pos)

	if not found_cell or not found_cell.is_free:
		return

	if self.money < item.cost:
		return
	self.money -= item.cost

	var item_pos = found_cell.get_center_position() + self.position
	item.position = item_pos
	item.current_cell = found_cell.index
	found_cell.is_free = false
	$Items.add_child(item)

func on_Frog_shoot(projectile):
	projectile.connect("exploded", self, "_on_Projectile_exploded")
	$Projectiles.add_child(projectile)

func _on_Projectile_exploded(explosion):
	$Projectiles.add_child(explosion)

func _ready():
	var count = 0
	var local_x = 0.0
	var local_y = 0.0
	var size = Vector2(h_slot_size, v_slot_size)
	for _i in range(horizontal_slots):
		local_y = 0
		for _j in range(vertical_slots):
			var from = Vector2(local_x, local_y)
			var to = from + size
			var new_cell = Cell.new(from, to, count)
			self.cells.append(new_cell)
			count += 1
			local_y += self.v_slot_size
		local_x += self.h_slot_size

func _process(_delta):
	update()

func _draw():
	var grid_color = Color(0, 0, 0.5)
	for cell in cells:
		if cell.is_free:
			draw_rect(
				Rect2(
					cell.top_left,
					cell.bottom_right - cell.top_left
				),
				grid_color,
				false
			)
		else:
			var local_color = grid_color.inverted()
			local_color.a = 0.2
			draw_rect(
				Rect2(
					cell.top_left,
					cell.bottom_right - cell.top_left
				),
				local_color,
				true
			)
