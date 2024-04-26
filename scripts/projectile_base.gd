extends CharacterBody2D
class_name ProjectileBase

@export_category("Statistics")
@export var bomb := false
@export var speed:int
@export var damage:int
@export var life_time := .5
@export var direction := Vector2.UP
var projectile_layer = 0b00000000_00000000_00000000_00001000
var projectile_check = 0b00000000_00000000_00000000_00000101
@export_category("Nodes")
@export var area_collison:Area2D

signal destroyed()

func _ready():
	collision_layer = projectile_layer
	area_collison.collision_mask = projectile_check
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = life_time
	timer.start()
	timer.timeout.connect(destroy_with_timer)
	rotation = direction.angle()
	area_collison.body_entered.connect(destroy)

func destroy_with_timer():
	queue_free()
	destroyed.emit()

func destroy(_node):
	if _node is Actor:
		_node.change_health_actor(-damage)
	destroyed.emit()
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity = direction *  speed
	move_and_slide()

"""
https://stackoverflow.com/questions/58570663/converting-vector-in-x-y-form-to-magnitude-angle-in-godot
angle() is how to get the angle
"""
