@tool
extends Node2D
class_name BaseDoor

@export_category("Information")
@export_enum("door", "wall") var door_type = 0
@export var closed:bool
@export_category("Sprites")
@export var open_door_sprite:Rect2
@export var locked_door_sprite:Rect2
@export var cracked_door_sprite:Rect2
@export var solid_door_sprite:Rect2
@export var top_sprite:Rect2
@export_category("nodes")
@export var door_collison_shape:CollisionShape2D
@export var door_area_check:Area2D
@export var low_sprite:Sprite2D
@export var high_sprite:Sprite2D
@export var linked_door:BaseDoor
@export var open_audio:AudioStreamPlayer
@export var explode_audio:AudioStreamPlayer

signal door_state_changed(closed_state)

func get_new_sprite(path:String, offset:Vector2, set_size:= Vector2.ZERO):
	# Change the sprite
	var dict_of_vectors = {
		0 : {
			true : locked_door_sprite,
			false : open_door_sprite
		},
		1 : {
			true : solid_door_sprite,
			false : cracked_door_sprite
		}
	}
	var new_sprite = AtlasTexture.new()
	var compressed_sprite = load(path)
	new_sprite.atlas = compressed_sprite
	var region : Rect2 = dict_of_vectors[door_type][closed]
	if set_size != Vector2.ZERO:
		region.size = set_size
	region.position += offset
	
	new_sprite.region = region
	return new_sprite


func bomb_open():
	if door_type == 1 and closed:
		explode_audio.play()
		change_state(false)


func change_sprites():
	low_sprite.texture = get_new_sprite("res://assets/tilesets/DungeonTiles.png", 
	Vector2(0, 0))
	
	high_sprite.texture = get_new_sprite("res://assets/tilesets/DungeonTiles.png", 
	top_sprite.position, top_sprite.size)


func _ready():
	change_sprites()
	door_area_check.body_entered.connect(check_key)
	if linked_door != null:
		linked_door.door_state_changed.connect(change_state)
	door_state_changed.emit(closed)

func change_state(new_bool_state:bool):
	closed = new_bool_state
	change_sprites()
	door_state_changed.emit(closed)


func check_key(node):
	if node.number_of_keys > 0 and closed:
		node.number_of_keys -= 1
		change_state(false)
		open_audio.play()

func _process(delta):
	if Engine.is_editor_hint():
		change_sprites()

func _physics_process(delta):
	if !closed:
		var static_body:StaticBody2D = door_collison_shape.get_parent()
		static_body.set_collision_layer_value(1, false)
