extends Position2D


signal spawned(enemy)

var spider_class = preload("res://enemies/spider/Spider.tscn")

func _on_Timer_timeout():
	var spider = spider_class.instance()
	var y = self.global_position.y
	var x = randi() % int(floor(($End.position - self.position).length()))
	spider.position = Vector2(x, y)
	emit_signal("spawned", spider)
