extends ProjectileBase
class_name Bomb

@onready var area_2d_2 = $Explosion

func explode():
	var nodes = area_2d_2.get_overlapping_bodies()
	for node in nodes:
		if node is Actor:
			node.change_health_actor(-damage)
		if "Door" in node.get_groups():
			node.get_parent().bomb_open()


func _on_destroyed():
	explode()
