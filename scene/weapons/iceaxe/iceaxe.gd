extends Weapon

var _attacking: bool = false
var _velocity: Vector2 = Vector2(0, 0)
var _acceleration: Vector2 = Vector2(0, 0)
var _rng = RandomNumberGenerator.new()
var _cooldown: float = 6.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	_rng.randomize()
	visible = _attacking


func _physics_process(delta: float) -> void:
	if !Global.frozen:
		visible = _attacking
		
		if !animated_sprite_2d.is_playing() and _attacking:
			animated_sprite_2d.play()
		elif animated_sprite_2d.is_playing() and !_attacking:
			animated_sprite_2d.stop()
		
		if _attacking:
			_velocity += _acceleration * delta
			position += _velocity * delta
			if _velocity.y > 120:
				_attacking = false
				can_delete = true
		
		_cooldown -= delta
		if _cooldown < 0:
			_start_attack()
			_cooldown = 6
	else:
		if animated_sprite_2d.is_playing():
			animated_sprite_2d.pause()


func _start_attack() -> void:
	_velocity = Vector2(0, -5)
	position = player.position + Vector2(0, -7)
	_attacking = true
	can_delete = false
	_acceleration = Vector2(_rng.randi_range(-10, 10), -100)
	await get_tree().create_timer(.2).timeout
	_acceleration.y = 100

#func _get_random_x_acceleration() -> int:
	#var accelx: int = 0
	#if _rng.randi_range(0 ,1) == 0:
		#accelx = _rng.randi_range(-30, -20)
		#animated_sprite_2d.flip_h = true
	#else:
		#accelx = _rng.randi_range(20, 30)
		#animated_sprite_2d.flip_h = false
	#return accelx

#func _get_random_x_acceleration() -> int:
	#var accelx: int = 0
	#if player.saved_rotation_vector.x > 0:
		#accelx = _rng.randi_range(-30, -20)
		#animated_sprite_2d.flip_h = true
	#else:
		#accelx = _rng.randi_range(20, 30)
		#animated_sprite_2d.flip_h = false
	#return accelx


func _on_area_2d_body_entered(body: Node2D) -> void:
	if _attacking:
		attack_enemy(body)
