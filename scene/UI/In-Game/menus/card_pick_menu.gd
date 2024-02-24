extends Control

signal picked_card(equipment_index: int)

var in_menu = false
var e_index: int = 0
var current_card: Card = null
var current_card_index = null
var scrolling_cards: Array = []
var inventory = []

@onready var card_display = $CardPicker/Card
@onready var card_description = $CardInfos/Description
@onready var ptarget_section = $CardInfos/PrimaryTargets
@onready var ptarget1 = $CardInfos/PrimaryTargets/EnemyIcon1
@onready var ptarget2 = $CardInfos/PrimaryTargets/EnemyIcon2

func open_menu(equipment_index):
	e_index = equipment_index
	inventory = Global.get_inventory()
	current_card = Global.get_equipped()[e_index]
	
	if current_card == null:
		current_card = Global.get_inventory()[0]
		
	current_card_index = inventory.find(current_card)
	_set_current_card()
	_initialize_card_list()
	# Ugly but without this, return button is automatically pressed when entering menu
	await get_tree().create_timer(0.1).timeout
	in_menu = true
	
func _initialize_card_list():
	# initialize list of possible card (do not show already equiped)
	scrolling_cards = []
	var all_inventory = Global.get_inventory()
	var equiped = Global.get_equipped()
	
	for card in all_inventory:
		if not (card in equiped) or card == current_card:
			scrolling_cards.append(card)
	
func _process(_delta):
	if in_menu:
		if Input.is_action_just_pressed("key_0"):
			var equipped = Global.get_equipped()
			equipped[e_index] = current_card
			Global.set_equipped(equipped)
			picked_card.emit(e_index)
			in_menu = false

		elif Input.is_action_just_pressed("key_6"):
			_next_card()
				
		elif Input.is_action_just_pressed("key_4"):
			_prev_card()
			

func _set_current_card():
	current_card = inventory[current_card_index]
	card_display.texture = current_card.card_texture
	card_description.text = current_card.description
	
	if current_card.type != "weapon":
		ptarget_section.set_visible(false)
	else:
		ptarget_section.set_visible(true)
		var enemies = current_card.get_damageable_enemies()
		ptarget1.texture = enemies[0].icon_texture
		ptarget2.texture = enemies[1].icon_texture
		
func _next_card():
	current_card_index += 1
	if current_card_index >= len(inventory):
		current_card_index = 0
	_set_current_card()
	
func _prev_card():
	current_card_index -= 1
	if current_card_index < 0:
		len(inventory) - 1
	_set_current_card()
	
