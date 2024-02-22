extends Camera2D

@export var target: Node2D


func _physics_process(delta):
	if target:
		_follow()


func _follow():
	position = target.position
