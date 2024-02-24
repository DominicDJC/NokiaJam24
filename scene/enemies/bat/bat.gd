class_name Bat extends Enemy2D

@onready var _bat = $Bat

func _physics_process(delta: float) -> void:
	if active:
		_bat_physics()
		_bat_animation()


func _bat_physics():
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


func _bat_animation():
	if Global.frozen:
		_bat.pause()
	else:
		if hurting:
			if _bat.animation != "hurt":
				_bat.play("hurt")
			if !_bat.is_playing():
				_bat.play()
			if _bat.frame == 3:
				hurting = false
		else:
			if _bat.animation != "flying":
				_bat.play("flying")
			if !_bat.is_playing():
				_bat.play()
			sprite_flipping(_bat)


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		contains_player = true


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		contains_player = false
