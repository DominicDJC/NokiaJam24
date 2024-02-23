extends Node2D

signal gameover
@export var ingameui: Control


func _ready():
	Global.reset_time()


# Handles the in-game ui, showing and hiding when time is frozen
func _process(delta):
	if Global.frozen and !ingameui.active:
		ingameui.activate()
	elif !Global.frozen and ingameui.active:
		ingameui.deactivate()
	
	Global.increment_time_elapsed(delta)
	
	#Debug code, please remove before release
	if Input.is_action_just_pressed("key_9"):
		emit_gameover()


func emit_gameover():
	gameover.emit()
