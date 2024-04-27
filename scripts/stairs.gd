extends StaticBody2D

@onready var teleport_marker = $TeleportMarker
@export var turn_off_topdown_controls := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enter_area_body_entered(body):
	body.can_move = false
	body.topdown_movement = !turn_off_topdown_controls
	var new_position =teleport_marker.global_position + Vector2(7.5+.1, 7.5)
	body.global_position = new_position
