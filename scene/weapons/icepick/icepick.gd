extends Weapon

var _speed: int = 75
var _cooldown: float = 4.0
var _attacking: bool = false
var _velocity: Vector2 = Vector2(0, 0)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	visible = _attacking
	
	if !Global.frozen:
		_cooldown -= delta
		if _cooldown < 0:
			_cooldown = 4.0
			_start_attack()
		
		if _attacking:
			position += _velocity * delta
			if player.position.distance_to(position) > 35:
				_attacking = false


func _start_attack() -> void:
	position = player.position
	var direction = player.saved_rotation_vector.normalized()
	var angle = direction.angle()
	position += direction * 4
	_velocity = direction * _speed
	animated_sprite_2d.rotation = angle
	match angle:
		0, 90, 180, 270:
			animated_sprite_2d.animation = "0"
		45, 135, 225, 315:
			animated_sprite_2d.animation = "45"
	animated_sprite_2d.play()
	_attacking = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if _attacking:
		attack_enemy(body)
