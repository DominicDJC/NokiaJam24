extends Weapon

@export var wait_time: float = 1.0
var _contained_enemies: Array = []
var _cooldown: float = wait_time
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	position = player.position
	if !Global.frozen:
		if !animated_sprite_2d.is_playing():
			animated_sprite_2d.play()
		
		_cooldown -= delta
		if _cooldown < 0 and _contained_enemies.size() > 0:
			_cooldown = wait_time
			for enemy in _contained_enemies:
				attack_enemy(enemy)
	else:
		if animated_sprite_2d.is_playing():
			animated_sprite_2d.pause()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body is Player):
		if !_contained_enemies.has(body):
			_contained_enemies.push_back(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if _contained_enemies.has(body):
		_contained_enemies.erase(body)
