@tool
extends StaticBody2D

@export var _item_resource:ItemResource

@onready var sprite_2d = $Sprite2D

func _ready():
	if _item_resource:
		sprite_2d.texture = _item_resource.sprite


func _physics_process(delta):
	if Engine.is_editor_hint():
		_ready()


func get_item():
	return _item_resource
