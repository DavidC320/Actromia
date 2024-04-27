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
var invulnerable = false
var can_attack := true
var moving := false

#
@onready var marker_2d = $Marker2D
@onready var margin_container_3 = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer3
@onready var invencible = $Invencible
@onready var label = $CanvasLayer/MarginContainer/VBoxContainer/Label
@onready var static_body_2d = $StaticBody2D
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D
@onready var timer = $Timer
@onready var item_sfx = $item_sfx
@onready var unlock_sfx = $unlock_sfx
@onready var ladder_detector = $LadderDetector
@onready var sprite_2d = $Sprite2D

#
const projectiles = {
	"sword" : preload("res://scenes/Projectiles/sword.tscn"),
	"sword beam" : preload("res://scenes/Projectiles/sword_beam.tscn"),
	"bomb" : preload("res://scenes/Projectiles/bomb.tscn"),
	"fire" : preload("res://scenes/Projectiles/fire.tscn")
}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	var animation_name = ''
	if !can_attack:
		animation_name += 'attack s '
	elif moving:
		animation_name += 'walk '
	else:
		animation_name += 'idle '
	
	var drection_name = {
		Vector2.UP : 'up',
		Vector2.DOWN : 'down',
		Vector2.LEFT : 'left',
		Vector2.RIGHT : 'right',
	}
	animation_name += drection_name.get(face_direction)
	sprite_2d.play(animation_name, 1.5)


func _ready():
	update_label()


func get_projectile(projectile_name:String, direction:Vector2, position:Vector2, layer, check):
	var projectile = projectiles.get(projectile_name).instantiate()
	projectile.position = position
	projectile.top_level = true
	projectile.projectile_layer = layer
	projectile.projectile_check = check
	projectile.direction = direction
	add_child(projectile)


func _input(event):
	if event.is_action_pressed("sword attack") and can_attack:
		can_attack = false
		timer.start()
		get_projectile("sword", marker_2d.position.normalized(), global_position + face_direction * 7, projectile_layer, 0b00000000_00000000_00000000_00000100)
		if health == health_max:
			# 0b00000000_00000000_00000000_10000101
			# 0b00000000_00000000_00000000_10000100
			get_projectile("sword beam", marker_2d.position.normalized(), global_position + face_direction * 7, projectile_layer, projectile_check)

	elif event.is_action_pressed("bomb") and number_of_bombs > 0:
		number_of_bombs -= 1
		update_label()
		get_projectile("bomb", Vector2.UP, global_position + face_direction * 7, projectile_layer, projectile_check)

	elif event.is_action_pressed("fire") and blue_candle_unlocked:
		get_projectile("fire", marker_2d.position.normalized(), global_position + face_direction * 7, projectile_layer, projectile_check)


func denormalize_vector(vector:Vector2):
	if vector.x < 0 or 0 < vector.x:
		vector.y = 0
	elif vector.y < 0 or 0 < vector.y:
		vector.x = 0
	return vector

func change_marker():
	marker_2d.position = face_direction * 16

func _physics_process(delta):
	if can_move and can_attack:
		movement_controls(delta) if topdown_movement or ladder_detector.get_overlapping_bodies() else platformer_controls(delta)
		static_body_2d.look_at(global_position + face_direction)
		collision_shape_2d.disabled = !can_attack or moving
		

func movement_controls(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction != face_direction and direction != Vector2.ZERO:
		face_direction = denormalize_vector(direction)
		change_marker()
	if direction:
		velocity = direction.normalized() * speed
		moving = true
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.x, 0, speed)
	move_and_slide()

func platformer_controls(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction != face_direction and direction != Vector2.ZERO:
		face_direction = denormalize_vector(direction)
		change_marker()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		moving = true
	else:
		moving = false
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_item_pick_body_entered(body):
	var item_data:ItemResource = body.get_item()
	if item_data.item_type == "item":
		item_sfx.play()
		if item_data.item == 0:
			number_of_keys += item_data.amount
		elif item_data.item == 1:
			number_of_bombs += item_data.amount
	if item_data.item_type == "unlock":
		unlock_sfx.play()
		if item_data.unlock_item == 0:
			blue_candle_unlocked = true
			margin_container_3.visible = true
	if item_data.item_type == "treasure":
		get_tree().change_scene_to_file("res://scenes/Menues/win.tscn")
	body.queue_free()
	update_label()

func die():
	invulnerable = true
	get_tree().change_scene_to_file("res://scenes/Menues/fail.tscn")
	pass

func update_label():
	label.text = "Health: %d/%d\nKeys: %d\nBombs: %d" % [health, health_max, number_of_keys, number_of_bombs]

func change_health_actor(damage:int):
	if !invulnerable:
		super(damage)
		invencible.start()
		invulnerable = true
	update_label()

func _on_invencible_timeout():
	invulnerable = false
	pass # Replace with function body.


func _on_timer_timeout():
	can_attack = true
	pass # Replace with function body.
