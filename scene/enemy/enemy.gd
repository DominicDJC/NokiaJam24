extends CharacterBody2D

enum Enemies {BAT}
@export var speed = 5
@export var _collision: CollisionShape2D
@export var _bat: AnimatedSprite2D
var health = Health.new()
var player: CharacterBody2D
var type = "null"
var active = false
var _virtual_position = Vector2(0, 0)
var _hurting = false



func _physics_process(delta):
	if active:
		match type:
			"bat":
				_bat_control()
				_bat_animation_control()


func init(new_player: CharacterBody2D, enemy_type: String, new_position: Vector2):
	if active:
		deactivate()
	player = new_player
	global_position = new_position
	_virtual_position = position
	type = enemy_type
	activate()


func hurt(damage):
	_hurting = true
	health.hurt(damage)
	if health.get_health() <= 0:
		kill()


func kill():
	deactivate()


func activate():
	health = Health.new()
	active = true
	visible = true
	if _bat.is_playing():
		_bat.pause()


func deactivate():
	active = false
	visible = false
	_bat.pause()


func _sprite_flipping(sprite: AnimatedSprite2D):
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func _bat_control():
	if !player or TIME.frozen:
		return
	
	var angle = global_position.angle_to_point(player.global_position)
	if _hurting:
		velocity = Vector2(cos(angle), sin(angle))
		velocity = velocity * -40
	else:
		velocity = Vector2(cos(angle), sin(angle))
		velocity = velocity * speed
	global_position = _virtual_position
	move_and_slide()
	_virtual_position = global_position
	global_position = round(global_position)


func _bat_animation_control():
	if TIME.frozen:
		_bat.pause()
	else:
		if _hurting:
			if _bat.animation != "hurt":
				_bat.play("hurt")
			if !_bat.is_playing():
				_bat.play()
			if _bat.frame == 2:
				_hurting = false
		else:
			if _bat.animation != "flying":
				_bat.play("flying")
			if !_bat.is_playing():
				_bat.play()
			_sprite_flipping(_bat)


func _on_attack_area_2d_body_entered(body):
	if body == player:
		player.hurt(10)
