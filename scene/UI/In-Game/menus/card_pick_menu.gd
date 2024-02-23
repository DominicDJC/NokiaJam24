extends Control

signal picked_card

var in_menu = false

func open_menu():
	# Ugly but without this, return button is automatically pressed when entering menu
	await get_tree().create_timer(0.1).timeout
	in_menu = true
	
func _process(_delta):
	if in_menu:
		if Input.is_action_just_pressed("key_0"):
			picked_card.emit()
			in_menu = false

		elif Input.is_action_just_pressed("key_6"):
			_next_card()
				
		elif Input.is_action_just_pressed("key_4"):
			_prev_card()
			
			
func _next_card():
	pass
	
func _prev_card():
	pass
