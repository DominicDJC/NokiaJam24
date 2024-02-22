extends Control

signal close_menu

@onready var equipment_menu = $EquipmentMenu

func _ready() -> void:
	equipment_menu.close_menu.connect(_close_menus)
	equipment_menu.set_visible(false)

func open_menu() -> void:
	equipment_menu.set_visible(true)
	equipment_menu.open_menu()

func _close_menus() -> void:
	equipment_menu.set_visible(false)
	close_menu.emit()

