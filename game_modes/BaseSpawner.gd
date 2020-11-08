extends Position2D


signal spawned(enemy)

var spider_class = preload("res://enemies/spider/Spider.tscn")

func spawn_spider():
	var spider = spider_class.instance()
	spider.position = self.position.linear_interpolate($End.position, randf())
	emit_signal("spawned", spider)
