extends Actor
class_name EnemyBase

@export_category("Statisitics")
@export var minimume_travel_distance := 1
@export var maximume_travel_distance := 3
@export_flags_2d_physics var projectile_layer = 0b00000000_00000000_00000000_00010000
@export_flags_2d_physics var projectile_check = 0b00000000_00000000_00000000_00000011
@export var recharge_time := 1.0
@export_category("Nodes")
@export var wall_ray:Node2D
@export var player_ray:Node2D
var recharge:Timer

var target_position:Vector2
var direction:Vector2
var recharging = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func play_animations():
	pass

func get_random_target_position():
	var random_direction = randi_range(0, 3)
	var direcotry_of_possible_directions = {
		0 : Vector2.UP,
		1 : Vector2.DOWN,
		2 : Vector2.LEFT,
		3 : Vector2.RIGHT,
	}
	var random_distance = randi_range(minimume_travel_distance, maximume_travel_distance)
	
	direction  = direcotry_of_possible_directions.get(random_direction)
	wall_ray.look_at(global_position + direction)
	player_ray.look_at(global_position + direction)
	target_position = global_position + (direction * 15)

func _process(delta):
	play_animations()

func _ready():
	get_random_target_position()
	var rechage_timer = Timer.new()
	rechage_timer.wait_time = recharge_time
	add_child(rechage_timer)
	recharge = rechage_timer
	rechage_timer.timeout.connect(recharge_timeout)


func get_collison_in_list(list_of_rays, group_check = null):
	for ray_cast_2d in list_of_rays:
		if ray_cast_2d.get_collider():
			if group_check:
				var object:Node2D = ray_cast_2d.get_collider()
				if object.is_in_group(group_check):
					return true
			else:
				return true
	return false


func player_found():
	recharge.start()


func move_enemy(delta):
	if global_position.distance_to(target_position) < .1:
		get_random_target_position()
		
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()


func check_rays():
	if get_collison_in_list(wall_ray.get_children()):
		get_random_target_position()
	
	if get_collison_in_list(player_ray.get_children(), "player") and !recharging:
		player_found()

func recharge_timeout():
	recharging = false
