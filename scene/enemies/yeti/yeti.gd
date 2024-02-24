class_name Yeti extends Enemy2D

@onready var _yeti = $Yeti


func _physics_process(delta: float) -> void:
	if active:
		_yeti_physics()
		_yeti_animation()


func _yeti_physics():
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


func _yeti_animation():
	if Global.frozen:
		_yeti.pause()
	else:
		if hurting:
			if _yeti.animation != "hurt":
				_yeti.play("hurt")
			if !_yeti.is_playing():
				_yeti.play()
			if _yeti.frame == 3:
				hurting = false
		else:
			if _yeti.animation != "running":
				_yeti.play("running")
			if !_yeti.is_playing():
				_yeti.play()
			sprite_flipping(_yeti)


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		contains_player = true


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		contains_player = false
