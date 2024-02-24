class_name Zombie extends Enemy2D

@export var speed = 5
@onready var _zombie = $Zombie

func _physics_process(delta: float) -> void:
	if active:
		_zombie_physics()
		_zombie_animation()


func _zombie_physics():
	if !player or Global.frozen:
		return
	var angle = global_position.angle_to_point(player.global_position)
	if hurting:
		velocity = Vector2(cos(angle), sin(angle))
		velocity = velocity * -40
	else:
		velocity = Vector2(cos(angle), sin(angle))
		velocity = velocity * speed
	fixed_move_and_slide()


func _zombie_animation():
	if Global.frozen:
		_zombie.pause()
	else:
		if hurting:
			if _zombie.animation != "hurt":
				_zombie.play("hurt")
			if !_zombie.is_playing():
				_zombie.play()
			if _zombie.frame == 3:
				hurting = false
		else:
			if _zombie.animation != "running":
				_zombie.play("running")
			if !_zombie.is_playing():
				_zombie.play()
			sprite_flipping(_zombie)


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		contains_player = true


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		contains_player = false
