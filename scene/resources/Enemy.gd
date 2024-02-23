class_name Enemy extends Resource

@export var name: String
@export var icon_texture: Texture

var HOT_GROUNDS = load("res://scene/resources/Data/Cards/Weapons/Hot Grounds.tres")
var ICE_AXE = load("res://scene/resources/Data/Cards/Weapons/Ice Axe.tres")
var ICE_PICK = load("res://scene/resources/Data/Cards/Weapons/Ice Pick.tres")
var SNOWBALL = load("res://scene/resources/Data/Cards/Weapons/Snowball.tres")


func get_supported_weapon() -> Card:
	var weapon: Card
	match name:
		"Bat", "Flying Skull":
			weapon = SNOWBALL
		"Zombie", "Yeti":
			weapon = ICE_PICK
		"Wolf", "Snake":
			weapon = ICE_AXE
		"Snowman", "Slime":
			weapon = HOT_GROUNDS
	return weapon
