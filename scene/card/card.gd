extends AnimatedSprite2D

@export var card: Card


func _physics_process(delta: float) -> void:
	if Global.frozen and is_playing():
		pause()
	elif !Global.frozen and !is_playing():
		play()


func init(new_card: Card, new_position: Vector2):
	card = new_card
	Global.world_card_counts[card.name] += 1
	global_position = new_position


func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is Player:
		body.pickup(card)
		Global.world_card_counts[card.name] -= 1
		get_parent().remove_child(self)
		queue_free()
