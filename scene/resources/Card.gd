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

const BAT = preload("res://scene/resources/Data/Enemies/Bat.tres")
const FLYING_SKULL = preload("res://scene/resources/Data/Enemies/FlyingSkull.tres")
const SLIME = preload("res://scene/resources/Data/Enemies/Slime.tres")
const SNAKE = preload("res://scene/resources/Data/Enemies/Snake.tres")
const SNOWMAN = preload("res://scene/resources/Data/Enemies/Snowman.tres")
const WOLF = preload("res://scene/resources/Data/Enemies/Wolf.tres")
const YETI = preload("res://scene/resources/Data/Enemies/Yeti.tres")
const ZOMBIE = preload("res://scene/resources/Data/Enemies/Zombie.tres")


func get_damageable_enemies() -> Array:
	var enemies = []
	var data = {
		"snowball": [FLYING_SKULL, BAT],
		"icepick": [ZOMBIE, YETI],
		"iceaxe": [WOLF, SNAKE],
		"hotgrounds": [SNOWMAN, SLIME]
	}
	if data.has(name):
		enemies = data[name]
	return []
