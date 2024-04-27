extends CharacterBody2D
class_name Actor
@export var speed:float= 10.0
@export var health:int = 1
@export var health_max:int = 1

@export var hurt_sound_effect:AudioStreamPlayer

var dead = false

signal damaged(new_health)

func play_hurt():
	hurt_sound_effect.play()

func change_health_actor(damage:int):
	play_hurt()
	health += damage
	if health < 0:
		health = 0
	elif health > health_max:
		health = health_max
	damaged.emit(health)
	
	if health == 0:
		dead = true
		die()

func die():
	queue_free()
