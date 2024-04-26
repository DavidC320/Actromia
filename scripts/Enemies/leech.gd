extends EnemyBase

var dash_speed_modifier:= 3
var dashing:= false
@onready var animated_sprite_2d = $AnimatedSprite2D

func player_found():
	dashing = true

func play_animations():
	var speed_scale = 1 if !dashing else 2
	if direction == Vector2.UP:
		animated_sprite_2d.play("up", speed_scale)
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("down", speed_scale)
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("left", speed_scale)
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("right", speed_scale)

func get_random_target_position():
	super()
	dashing = false

func move_enemy(delta):
	if global_position.distance_to(target_position) < .1 and !dashing:
		get_random_target_position()
	
	var new_speed = speed
	if dashing:
		new_speed = speed * dash_speed_modifier
	
	if direction:
		velocity = direction * new_speed
	else:
		velocity.x = move_toward(velocity.x, 0, new_speed)
		velocity.y = move_toward(velocity.y, 0, new_speed)

	move_and_slide()

func _physics_process(delta):
	check_rays()
	
	if !recharging:
		move_enemy(delta)
