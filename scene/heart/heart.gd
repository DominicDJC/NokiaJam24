extends AnimatedSprite2D

@export var value: int = 5


func init(new_position: Vector2):
	global_position = new_position


func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health.heal(value)
		get_parent().remove_child(self)
		queue_free()
