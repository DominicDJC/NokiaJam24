extends AnimatedSprite2D

@export var value: int = 5
@export var pickup_sound: AudioStream


func _physics_process(delta: float) -> void:
	if Global.frozen and is_playing():
		pause()
	elif !Global.frozen and !is_playing():
		play()


func init(new_position: Vector2):
	global_position = new_position


func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.play_audio(pickup_sound)
		body.health.heal(value)
		get_parent().remove_child(self)
		queue_free()
