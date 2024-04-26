extends Actor


@export_flags_2d_physics var projectile_layer = 0b00000000_00000000_00000000_0001000
@export_flags_2d_physics var projectile_check = 0b00000000_00000000_00000000_00000101

#
var number_of_keys := 0
var number_of_bombs := 1
const JUMP_VELOCITY = -400.0

#
var blue_candle_unlocked = false

#
var face_direction := Vector2.UP
var can_move := true
var topdown_movement = true

#
@onready var marker_2d = $Marker2D

#
const projectiles = {
	"sword" : preload("res://scenes/Projectiles/sword.tscn"),
	"sword beam" : preload("res://scenes/Projectiles/sword_beam.tscn"),
	"bomb" : preload("res://scenes/Projectiles/bomb.tscn"),
	"fire" : preload("res://scenes/Projectiles/fire.tscn")
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func get_projectile(projectile_name:String, direction:Vector2, position:Vector2):
	var projectile = projectiles.get(projectile_name).instantiate()
	projectile.position = position
	projectile.top_level = true
	projectile.projectile_layer = projectile_layer
	projectile.projectile_check = projectile_check
	projectile.direction = direction
	add_child(projectile)


func _input(event):
	if event.is_action_pressed("sword attack"):
		get_projectile("sword", marker_2d.position.normalized(), global_position)
		if health == health_max:
			get_projectile("sword beam", marker_2d.position.normalized(), global_position)

	elif event.is_action_pressed("bomb") and number_of_bombs > 0:
		number_of_bombs -= 1
		get_projectile("bomb", Vector2.UP, global_position)

	elif event.is_action_pressed("fire") and blue_candle_unlocked:
		get_projectile("fire", marker_2d.position.normalized(), global_position)


func change_marker():
	if face_direction.x < 0 or 0 < face_direction.x:
		marker_2d.position.y = 0
		marker_2d.position.x = face_direction.x * 16
	if face_direction.y < 0 or 0 < face_direction.y:
		marker_2d.position.x = 0.0
		marker_2d.position.y = face_direction.y * 16


func _physics_process(delta):
	if can_move:
		movement_controls(delta) if topdown_movement else platformer_controls(delta)

func movement_controls(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction != face_direction and direction != Vector2.ZERO:
		face_direction = direction
	change_marker()
	if direction:
		velocity = direction.normalized() * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.x, 0, speed)

	move_and_slide()

func platformer_controls(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_item_pick_body_entered(body):
	var item_data:ItemResource = body.get_item()
	if item_data.item_type == "item":
		if item_data.item == 0:
			number_of_keys += item_data.amount
		elif item_data.item == 1:
			number_of_bombs += item_data.amount
	if item_data.item_type == "unlock":
		if item_data.unlock_item == 0:
			blue_candle_unlocked = true
	body.queue_free()

func die():
	pass
