extends CharacterBody2D


@export var speed = 15

@onready var _player_sprite = $PlayerSprite

var health = Health.new()
var moving = false
var _virtual_position = Vector2(0.0, 0.0)
var _cooldown = 0.0
var _hurting = false


func hurt(damage):
	_hurting = true
	health.hurt(damage)
	print("Player health: " + str(health.get_health()))
	if health.get_health() <= 0:
		kill()


func kill():
	print("Player should have died here")


func _get_input():
	var input_direction = Input.get_vector("key_4", "key_6", "key_2", "key_8")
	moving = (input_direction != Vector2(0, 0)) or (Input.is_action_pressed("key_5"))
	velocity = input_direction * speed


func _physics_process(delta):
	_update_player_sprite()
	
	_get_input()
	position = _virtual_position
	move_and_slide()
	_virtual_position = position
	position = round(position)
	
	_cooldown -= delta
	if _cooldown < 0:
		_cooldown = 0
	if moving:
		Global.unfreeze()
		_cooldown = 0.3
	elif _cooldown <= 0:
		Global.freeze()


func _update_player_sprite():
	if _hurting:
		if _player_sprite.animation != "hurt":
			_player_sprite.play("hurt")
		if !_player_sprite.is_playing():
			_player_sprite.play()
		if _player_sprite.frame == 2:
			_hurting = false
	else:
		if velocity != Vector2(0, 0):
			if _player_sprite.animation != "right":
				_player_sprite.play("right")
		else:
			if _player_sprite.animation != "idle":
				_player_sprite.play("idle")
		if !_player_sprite.is_playing():
			_player_sprite.play()
	_sprite_flipping()


func _sprite_flipping():
	if velocity.x > 0:
		_player_sprite.flip_h = false
		_player_sprite.offset.x = 0
	elif velocity.x < 0:
		_player_sprite.flip_h = true
		_player_sprite.offset.x = 2
