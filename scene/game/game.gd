extends Node2D

signal gameover
@export var ingameui: Control
@export var card_pickup: Control


func _ready():
	Global.stop_audio()
	Global.game = self
	Global.reset_time_elapsed()
	Global.clear_inventory()
	Global.add_to_inventory(load("res://scene/resources/Data/Cards/Weapons/Snowball.tres"))
	Global.set_equipcard1(Global.get_inventory()[0])


# Handles the in-game ui, showing and hiding when time is frozen
func _process(delta):
	if Global.frozen and !ingameui.active:
		ingameui.activate()
	elif !Global.frozen and ingameui.active:
		ingameui.deactivate()
	
	if !Global.frozen:
		Global.increment_time_elapsed(delta)
	
	#Debug code, please remove before release
	#if Input.is_action_just_pressed("key_9"):
		#emit_gameover()


func emit_gameover():
	gameover.emit()
