extends Node2D

@export var player: CharacterBody2D
var _rng = RandomNumberGenerator.new()

const BAT = preload("res://scene/enemies/bat/bat.tscn")
const FLYINGSKULL = preload("res://scene/enemies/flyingskull/flyingskull.tscn")
const ZOMBIE = preload("res://scene/enemies/zombie/zombie.tscn")
const YETI = preload("res://scene/enemies/yeti/yeti.tscn")
const SNAKE = preload("res://scene/enemies/snake/snake.tscn")
const WOLF = preload("res://scene/enemies/wolf/wolf.tscn")
const SLIME = preload("res://scene/enemies/slime/slime.tscn")
const SNOWMAN = preload("res://scene/enemies/snowman/snowman.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_rng.randomize()
	#new_enemy("bat")
	for i in 1:
		new_enemy("Snowman")
		await get_tree().create_timer(5).timeout


func new_enemy(type: String):
	var target: Enemy2D
	for child in get_children():
		if child.is_class(type) and !child.active:
			target = child
			break
	if !target:
		match type:
			"Bat":
				target = BAT.instantiate()
			"FlyingSkull":
				target = FLYINGSKULL.instantiate()
			"Zombie":
				target = ZOMBIE.instantiate()
			"Yeti":
				target = YETI.instantiate()
			"Snake":
				target = SNAKE.instantiate()
			"Wolf":
				target = WOLF.instantiate()
			"Slime":
				target = SLIME.instantiate()
			"Snowman":
				target = SNOWMAN.instantiate()
	target.init(player, _get_spawn_position())
	add_child(target)


func _print_enemies():
	var string = "[Total:"
	string += str(get_child_count())
	for child in get_children():
		string += ","
		string += child.type
		string += ":"
		string += str(child.active)
		string += ":"
		string += str(child.health.get_health())
	string += "]"
	print(string)


func _get_spawn_position() -> Vector2:
	var player_position = player.global_position
	var spawn_position = Vector2(0, 0)
	match _rng.randi_range(0, 3):
		0: # above
			spawn_position.x = player_position.x + _rng.randi_range(-60, 60)
			spawn_position.y = player_position.y + 40
		1: # below
			spawn_position.x = player_position.x + _rng.randi_range(-60, 60)
			spawn_position.y = player_position.y - 40
		2: # right
			spawn_position.x = player_position.x + 60
			spawn_position.y = player_position.y + _rng.randi_range(-40, 40)
		3: # left
			spawn_position.x = player_position.x - 60
			spawn_position.y = player_position.y + _rng.randi_range(-40, 40)
	return spawn_position

