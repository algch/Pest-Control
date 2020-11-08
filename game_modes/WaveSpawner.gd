extends "res://game_modes/BaseSpawner.gd"


var wave_enemies = 0
var current_wave

var min_wait_time = 2
var max_wait_time = 5

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	start_wave(1)

func _on_Timer_timeout():
	.spawn_spider()
	self.wave_enemies -= 1
	if wave_enemies:
		start_timer()

func _on_LabelTimer_timeout():
	$CanvasLayer/Control.visible = false

func start_wave(wave_number):
	self.current_wave = wave_number
	self.wave_enemies = int(2 * pow(1.3, wave_number))
	self.set_label("Wave " + str(wave_number))
	start_timer()

func set_label(text):
	$CanvasLayer/Control/Label.set_text(text)
	$CanvasLayer/Control.visible = true
	$LabelTimer.start()

func start_timer():
	var wait_time = min_wait_time + (max_wait_time - min_wait_time) * randf()
	$Timer.set_wait_time(wait_time)
	$Timer.start()
