class_name Enemy extends Resource

@export var name: String
@export var icon_texture: Texture

const HOT_GROUNDS = preload("res://scene/resources/Data/Cards/Weapons/Hot Grounds.tres")
const ICE_AXE = preload("res://scene/resources/Data/Cards/Weapons/Ice Axe.tres")
const ICE_PICK = preload("res://scene/resources/Data/Cards/Weapons/Ice Pick.tres")
const SNOWBALL = preload("res://scene/resources/Data/Cards/Weapons/Snowball.tres")


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
