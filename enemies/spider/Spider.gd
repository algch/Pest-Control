extends "res://enemies/Enemy.gd"

func _on_ObjectiveCheckTimer_timeout():
    var collider = $ObjectiveChecker.get_collider()
    print("collider found ", collider)
    if collider and collider.has_method("handle_spider_attack"):
        collider.handle_spider_attack(self)


