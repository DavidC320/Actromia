extends EnemyBase

const SWORD_BEAM = preload("res://scenes/Projectiles/sword_beam.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D

func play_animations():
	if !recharging:
		animated_sprite_2d.play("default")
	elif direction == Vector2.UP:
		animated_sprite_2d.play("up laser")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("down laser")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("left laser")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("right laser")

func player_found():
	var enemy_projectile = SWORD_BEAM.instantiate()
	enemy_projectile.top_level = true
	enemy_projectile.direction = direction
	enemy_projectile.projectile_layer = projectile_layer
	enemy_projectile.projectile_check = projectile_check
	add_child(enemy_projectile)
	enemy_projectile.global_position = global_position #+ direction * 7
	recharging = true
	recharge.start()

func _physics_process(delta):
	check_rays()
	
	if !recharging:
		move_enemy(delta)
