extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var node = $Node
const GLIMBAT = preload("res://scenes/enemies/Glimbat.tscn")

var died = false

func play_animations():
	if recharging:
		animated_sprite_2d.play("default")
	else:
		animated_sprite_2d.play("fly")

func get_random_target_position():
	if recharging:
		return
	var random_direction = randi_range(0, 3)
	var direcotry_of_possible_directions = {
		0 : (Vector2.UP + Vector2.LEFT).normalized(),
		1 : (Vector2.DOWN + Vector2.LEFT).normalized(),
		2 : (Vector2.DOWN + Vector2.RIGHT).normalized(),
		3 : (Vector2.UP + Vector2.RIGHT).normalized(),
	}
	var random_distance = randi_range(minimume_travel_distance, maximume_travel_distance)
	
	direction  = direcotry_of_possible_directions.get(random_direction)
	wall_ray.look_at(global_position + direction)
	player_ray.look_at(global_position + direction)
	hit_player_area.look_at(global_position + direction)
	target_position = global_position + (direction * 15)
	recharging = true
	recharge.start()


func die():
	died = true

func true_die():
	queue_free()


func _physics_process(delta):
	if died:
		for mark in node.get_children():
			var new_bat = GLIMBAT.instantiate()
			new_bat.global_position = mark.global_position
			new_bat.top_level = true
			get_tree().get_first_node_in_group("enemies").add_child(new_bat)
			print(new_bat.global_position)
		true_die()
	
	check_rays()
	
	if !recharging:
		move_enemy(delta)
