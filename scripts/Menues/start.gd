extends Control

@onready var play = $VBoxContainer/MarginContainer/VBoxContainer/play
@onready var credits = $VBoxContainer/MarginContainer/VBoxContainer/Credits
@onready var quit = $VBoxContainer/MarginContainer/VBoxContainer/quit


# Called when the node enters the scene tree for the first time.
func _ready():
	play.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Menues/intro.tscn"))
	credits.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Menues/credits.tscn"))
	quit.pressed.connect(func(): get_tree().quit())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
