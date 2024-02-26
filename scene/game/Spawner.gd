extends Node2D

@export var player: CharacterBody2D
var _rng = RandomNumberGenerator.new()
var _desired_enemy_count: int = 0
var _max_cooldown: float = 2.5
var _cooldown: float = 0.0

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
	#new_enemy("Bat")


func _physics_process(delta: float) -> void:
	if !Global.frozen:
		# Start with 10, go up 1 every 30 secs
		_desired_enemy_count = (Global.time_elapsed / 15) + 10
		_max_cooldown = 2 - pow(Global.time_elapsed / 430, 2)
		_cooldown -= delta
		if _cooldown < 0 and _total_enemies() < _desired_enemy_count:
			_cooldown = _max_cooldown
			new_enemy(_pick_enemy())


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
	target.init(player)
	add_child(target)


func _pick_enemy() -> String:
	var inventory_data: Dictionary = Global.card_counts
	var time_elapsed: float = Global.time_elapsed
	var diff_monsters: bool = 2 < (inventory_data["Attack Up"] + inventory_data["Shield Up"] + inventory_data["Health Up"])
	var possible_enemies: Array = ["Bat"]
	if diff_monsters:
		possible_enemies.append("FlyingSkull")
	if time_elapsed > 120 or inventory_data["Ice Pick"] > 0:
		possible_enemies.append("Zombie")
		if diff_monsters:
			possible_enemies.append("Yeti")
	if time_elapsed > 180 or inventory_data["Ice Axe"] > 0:
		possible_enemies.append("Snake")
		if diff_monsters:
			possible_enemies.append("Wolf")
	if time_elapsed > 240 or inventory_data["Hot Grounds"] > 0:
		possible_enemies.append("Slime")
		if diff_monsters:
			possible_enemies.append("Snowman")
	return possible_enemies[_rng.randi_range(0, possible_enemies.size() - 1)]


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


func _total_enemies() -> int:
	var count: int = 0
	for child in get_children():
		if child.active:
			count += 1
	return count
