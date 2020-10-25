extends Particles2D


func _ready():
	$PunchSound.play()

func _on_Timer_timeout():
	queue_free()
