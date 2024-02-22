extends Control

# 1280x720

var in_menu: bool = false

@onready var game_ui = $GameUI
@onready var menus = $Menus
@onready var freeze_ui = $GameUI/FreezeUI
@onready var pause_ap = $GameUI/AnimationPlayer

## Current active state. Used by the game node in game.tscn
var active = true

func _ready() -> void:
	menus.close_menu.connect(_close_menu)

func _process(_delta):
	if active and not in_menu:
		if Input.is_action_just_pressed("key_0"):
			in_menu = true
			game_ui.set_visible(false)
			menus.open_menu()
		
## GameUI activation script. Will run once when time is frozen
func activate():
	active = true
	pause_ap.play("freeze_in")

## GameUI deactivation script. Will run once when time is unfrozen
func deactivate():
	active = false
	pause_ap.play("freeze_out")

func _close_menu() -> void:
	in_menu = false
	game_ui.set_visible(true)
