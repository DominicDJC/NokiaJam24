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
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func open_menu(equipment_index):
	e_index = equipment_index
	inventory = Global.get_inventory()
	current_card = Global.get_equipped()[e_index]
	_initialize_card_list()
	
	if current_card == null:
		current_card = scrolling_cards[0]
		
	current_card_index = scrolling_cards.find(current_card)
	_set_current_card()
	# Ugly but without this, return button is automatically pressed when entering menu
	await get_tree().create_timer(0.1).timeout
	in_menu = true


func _initialize_card_list():
	scrolling_cards.clear()
	# initialize list of possible card (do not show already equiped)
	for card in inventory:
		scrolling_cards.append(card)
	var equiped = Global.get_equipped()
	
	for card in equiped:
		if scrolling_cards.has(card):
			scrolling_cards.erase(card)
	if current_card:
		scrolling_cards.append(current_card)


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
	current_card = scrolling_cards[current_card_index]
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
	animation_player.stop()
	animation_player.play("Right")
	current_card_index += 1
	if current_card_index >= len(scrolling_cards):
		current_card_index = 0
	_set_current_card()
	
func _prev_card():
	animation_player.stop()
	animation_player.play("Left")
	current_card_index -= 1
	if current_card_index < 0:
		current_card_index = len(scrolling_cards) - 1
	_set_current_card()
	
