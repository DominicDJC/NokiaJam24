extends Control

signal close_menu 

var in_menu: bool = false

@onready var return_button = $ReturnToGameButton
@onready var slot1 = $Equipment/Slot1
@onready var slot2 = $Equipment/Slot2
@onready var slot3 = $Equipment/Slot3

func open_menu():
	return_button.grab_focus()
	# Ugly but without this, return button is automatically pressed when entering menu
	await get_tree().create_timer(0.1).timeout
	in_menu = true

func _process(_delta):
	if in_menu:
		var focus_owner = get_viewport().gui_get_focus_owner()
		if Input.is_action_just_pressed("key_0"):
			match focus_owner:
				return_button:
					close_menu.emit()
					in_menu = false
		
		elif Input.is_action_just_pressed("key_6"):
			var neighbor = focus_owner.find_valid_focus_neighbor(SIDE_RIGHT)
			if neighbor:
				neighbor.grab_focus()
				
		elif Input.is_action_just_pressed("key_4"):
			var neighbor = focus_owner.find_valid_focus_neighbor(SIDE_LEFT)
			if neighbor:
				neighbor.grab_focus()

func card_focused(card):
	var tween = create_tween()
	card.z_index = 1
	tween.tween_property(card, "position:y", 9, 0.1)

func card_unfocused(card):
	var tween = create_tween()
	card.z_index = 0
	tween.tween_property(card, "position:y", 12, 0.1)


func _on_slot_1_focus_entered():
	card_focused(slot1)
	
func _on_slot_1_focus_exited():
	card_unfocused(slot1)


func _on_slot_2_focus_entered():
	card_focused(slot2)


func _on_slot_2_focus_exited():
	card_unfocused(slot2)


func _on_slot_3_focus_entered():
	card_focused(slot3)


func _on_slot_3_focus_exited():
	card_unfocused(slot3)
