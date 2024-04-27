extends StaticBody2D

@onready var target_position:Vector2 = self.global_position
var moved = false

@onready var up := $up
@onready var down := $down
@onready var left := $left
@onready var right := $right

func _ready():
	up.body_entered.connect(func(_node): change_direction(_node, Vector2.UP))
	down.body_entered.connect(func(_node): change_direction(_node, Vector2.DOWN))
	left.body_entered.connect(func(_node): change_direction(_node, Vector2.LEFT))
	right.body_entered.connect(func(_node): change_direction(_node, Vector2.RIGHT))

func _physics_process(delta):
	global_position = lerp(global_position, target_position, .6)

func change_direction(_node, direction: Vector2):
	if !moved:
		target_position = global_position - direction * 15
		moved = true
