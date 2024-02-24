class_name FlyingSkull extends Enemy2D

@onready var _flyingskull = $Flyingskull

#func _physics_process(delta: float) -> void:
	#if active:
		#_flyingskull_physics()
		#_flyingskull_animation()


func _flyingskull_physics():
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


func _flyingskull_animation():
	if Global.frozen:
		_flyingskull.pause()
	else:
		if hurting:
			if _flyingskull.animation != "hurt":
				_flyingskull.play("hurt")
			if !_flyingskull.is_playing():
				_flyingskull.play()
			if _flyingskull.frame == 3:
				hurting = false
		else:
			if _flyingskull.animation != "flying":
				_flyingskull.play("flying")
			if !_flyingskull.is_playing():
				_flyingskull.play()
			sprite_flipping(_flyingskull)


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		contains_player = true


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		contains_player = false
