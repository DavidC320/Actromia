extends Control
@onready var play = $VBoxContainer/Play
@onready var back = $VBoxContainer/Back


# Called when the node enters the scene tree for the first time.
func _ready():
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Menues/start.tscn"))
	play.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/dungeon_room.tscn"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
