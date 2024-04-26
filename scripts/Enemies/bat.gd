extends EnemyBase

func get_random_target_position():
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
	target_position = global_position + (direction * 15)

func _physics_process(delta):
	check_rays()
	
	if !recharging:
		move_enemy(delta)
