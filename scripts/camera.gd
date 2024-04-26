extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var moving := false
var target_position = Vector2.ZERO
var next_position = Vector2.ZERO

@export var player:CharacterBody2D
@onready var limit = $Limit

func get_player_input_direction():
	var limit_vector = Vector4(
		global_position.x,
		global_position.y, 
		global_position.x + 240, 
		global_position.y + 165)

	var left_of_camera:bool = limit_vector.x > player.global_position.x
	var right_of_camera:bool = limit_vector.z < player.global_position.x
	var up_of_camera:bool = limit_vector.y > player.global_position.y
	var down_of_camera:bool = limit_vector.w < player.global_position.y
	if true in [left_of_camera, right_of_camera, up_of_camera, down_of_camera]:
		var increment := Vector2(
			int(return_int_with_tri(left_of_camera, right_of_camera, -1, 0, 1) * 240),
			int(return_int_with_tri(up_of_camera, down_of_camera, -1, 0, 1) * 165))
		target_position = global_position + increment
		player.can_move = false

func return_int_with_tri(top_bool, bottom_bool, top_value, mid_value, bottom_value):
	if top_bool:
		return top_value
	elif bottom_bool:
		return bottom_value
	else:
		return mid_value

func _physics_process(delta):
	if position.distance_to(target_position) < .5:
		position = target_position
		player.can_move = true
	if position == target_position:
		get_player_input_direction()
	position = lerp(position, target_position, .2)
