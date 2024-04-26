extends ProjectileBase
class_name Bomb

@onready var area_2d_2 = $Explosion

func explode():
	var nodes = area_2d_2.get_overlapping_bodies()
	for node in nodes:
		if node is TileMap:
			continue
		if node.collision_layer == 1 and "Door" in node.get_groups():
			node.get_parent().bomb_open()
		elif node.collision_layer == 1:
			continue
		else:
			node.health -= damage


func _on_destroyed():
	explode()
