extends Control

signal close_menu 
signal card_menu(equipment_idx: int)

var in_menu: bool = false

@onready var return_button = $ReturnToGameButton
@onready var slot1 = $Equipment/Slot1
@onready var slot2 = $Equipment/Slot2
@onready var slot3 = $Equipment/Slot3
@onready var slots = [slot1, slot2, slot3]

@onready var no_card_texture = preload("res://assets/img/UI/In-Game/cards/cards_nocard.png")

func _ready():
	_refresh_menu()

func _refresh_menu():
	var equiped = Global.get_equipped()
	
	for i in range(3):
		if equiped[i] != null:
			slots[i].texture_normal = equiped[i].card_texture
		else:
			slots[i].texture_normal = no_card_texture
	
func open_menu(equipment_index = 0):
	slots[equipment_index].grab_focus()
	
	_refresh_menu()
	# Ugly but without this, return button is automatically pressed when entering menu
	await get_tree().create_timer(0.1).timeout
	in_menu = true

func _can_open():
	var n_equipped = 0
	for equipment in Global.get_equipped():
		if equipment != null:
			n_equipped += 1
	
	if n_equipped >= len(Global.get_inventory()):
		return false
	
	return true

func _process(_delta):
	if in_menu:
		var focus_owner = get_viewport().gui_get_focus_owner()
		if Input.is_action_just_pressed("key_0"):
			Global.ui_sound()
			match focus_owner:
				return_button:
					close_menu.emit()
					in_menu = false
				
				slot1:
					if _can_open():
						card_menu.emit(0)
						in_menu = false
					
				slot2:
					if _can_open():
						card_menu.emit(1)
						in_menu = false
					
				slot3:
					if _can_open():
						card_menu.emit(2)
						in_menu = false
		
		elif Input.is_action_just_pressed("key_6"):
			Global.ui_sound()
			var neighbor = focus_owner.find_valid_focus_neighbor(SIDE_RIGHT)
			if neighbor:
				neighbor.grab_focus()
				
		elif Input.is_action_just_pressed("key_4"):
			Global.ui_sound()
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
