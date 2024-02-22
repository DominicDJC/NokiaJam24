extends Node2D

@export var ingameui: Control

# Handles the in-game ui, showing and hiding when time is frozen
func _process(delta):
	if TIME.frozen and !ingameui.active:
		ingameui.activate()
	elif !TIME.frozen and ingameui.active:
		ingameui.deactivate()
