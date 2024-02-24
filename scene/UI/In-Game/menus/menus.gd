extends Control

signal close_menu

@onready var equipment_menu = $EquipmentMenu
@onready var card_pick_menu = $CardPickMenu

func _ready() -> void:
	equipment_menu.set_visible(false)
	card_pick_menu.set_visible(false)
	
	equipment_menu.close_menu.connect(_close_menus)
	equipment_menu.card_menu.connect(_open_card_menu)
	card_pick_menu.picked_card.connect(_equip_card)

func open_menu() -> void:
	card_pick_menu.set_visible(false)
	equipment_menu.set_visible(true)
	equipment_menu.open_menu()

func _close_menus() -> void:
	equipment_menu.set_visible(false)
	close_menu.emit()

func _open_card_menu(equipment_index):
	equipment_menu.set_visible(false)
	card_pick_menu.set_visible(true)
	card_pick_menu.open_menu(equipment_index)

func _equip_card(equipment_index):
	equipment_menu.set_visible(true)
	card_pick_menu.set_visible(false)
	equipment_menu.open_menu(equipment_index)
