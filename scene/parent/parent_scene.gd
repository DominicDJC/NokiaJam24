extends Node

@onready var main_menu = preload("res://scene/UI/MainMenu/main_menu.tscn")
@onready var game = preload("res://scene/game/game.tscn")
@onready var game_over = preload("res://scene/UI/GameOver/game_over.tscn")
@onready var tutorial = preload("res://scene/tutorial/tutorial.tscn")
@onready var stats = preload("res://scene/stats/stats.tscn")


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
	mm.start_game.connect(self._load_tutorial)
	add_child(mm)


func _load_game():
	_clear_current_scene()
	var g = game.instantiate()
	g.gameover.connect(self._load_game_over)
	add_child(g)


func _load_game_over():
	_clear_current_scene()
	var go = game_over.instantiate()
	go.done.connect(self._load_stats)
	add_child(go)


func _load_tutorial():
	_clear_current_scene()
	var tu = tutorial.instantiate()
	tu.done.connect(self._load_game)
	add_child(tu)


func _load_stats():
	_clear_current_scene()
	var st = stats.instantiate()
	st.done.connect(self._load_main_menu)
	add_child(st)
