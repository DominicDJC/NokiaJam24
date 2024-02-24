extends Node

@onready var main_menu = preload("res://scene/UI/MainMenu/main_menu.tscn")
@onready var game = preload("res://scene/game/game.tscn")
@onready var game_over = preload("res://scene/UI/GameOver/game_over.tscn")


func _ready():
	#_load_main_menu()
	_load_game()

# We can remove this when we don't need it anymore. This will play the game
#func _process(delta):
#	if Input.is_action_just_pressed("key_0"):
#		_load_game()


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
	g.gameover.connect(self._load_game_over)
	add_child(g)


func _load_game_over():
	_clear_current_scene()
	var go = game_over.instantiate()
	add_child(go)
