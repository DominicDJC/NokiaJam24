extends Node

@onready var main_menu = preload("res://scene/UI/MainMenu/main_menu.tscn")
@onready var game = preload("res://scene/game/game.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	_load_main_menu()


func _clear_current_scene():
	if get_child(0):
		var current_scene = get_child(0)
		remove_child(current_scene)
		current_scene.queue_free()


func _load_main_menu():
	_clear_current_scene()
	var mm = main_menu.instantiate()
	mm.start_game.connect(self._load_game)
	add_child(mm)


func _load_game():
	_clear_current_scene()
	var g = game.instantiate()
	add_child(g)
