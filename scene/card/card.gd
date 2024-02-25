extends AnimatedSprite2D

@export var card: Card


func init(new_card: Card, new_position: Vector2):
	card = new_card
	global_position = new_position


func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is Player:
		body.pickup(card)
		get_parent().remove_child(self)
		queue_free()
