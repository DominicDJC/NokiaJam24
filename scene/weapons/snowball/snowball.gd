extends Weapon

var _distance_from_player = 15
var _rotation_speed = 3
var _angle = 0


func _ready() -> void:
	position = round(player.position + (_distance_from_player * Vector2(cos(_angle), sin(_angle))))


func _physics_process(delta):
	if !Global.frozen:
		_angle += _rotation_speed * delta
		position = round(player.position + (_distance_from_player * Vector2(cos(_angle), sin(_angle))))


func _on_area_2d_body_entered(body: Node2D) -> void:
	attack_enemy(body)
