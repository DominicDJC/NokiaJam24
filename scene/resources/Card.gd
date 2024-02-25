class_name Card extends Resource

@export var name: String
@export var description: String
@export var card_texture: Texture
@export_enum("weapon", "buff") var type: String
@export_enum("snowball", "icepick", "iceaxe", "hotgrounds") var weapon: String
@export var effects: Dictionary = {
	"health":0,
	"damage":0,
	"speed":0,
	"defense":0,
	"time":0,
}

var BAT = load("res://scene/resources/Data/Enemies/Bat.tres")
var FLYING_SKULL = load("res://scene/resources/Data/Enemies/FlyingSkull.tres")
var SLIME = load("res://scene/resources/Data/Enemies/Slime.tres")
var SNAKE = load("res://scene/resources/Data/Enemies/Snake.tres")
var SNOWMAN = load("res://scene/resources/Data/Enemies/Snowman.tres")
var WOLF = load("res://scene/resources/Data/Enemies/Wolf.tres")
var YETI = load("res://scene/resources/Data/Enemies/Yeti.tres")
var ZOMBIE = load("res://scene/resources/Data/Enemies/Zombie.tres")


func get_damageable_enemies() -> Array:
	var enemies = []
	var data = Global.get_card_enemy_data()
	#var data = {
		#"snowball": [FLYING_SKULL, BAT],
		#"icepick": [ZOMBIE, YETI],
		#"iceaxe": [WOLF, SNAKE],
		#"hotgrounds": [SNOWMAN, SLIME]
	#}
	print(data)
	if data.has(weapon):
		enemies = data[weapon]
	return enemies
