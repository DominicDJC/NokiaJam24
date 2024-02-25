extends Node

# Starting card
#var snowball = preload("res://scene/resources/Data/Cards/Weapons/Snowball.tres")

## Whether or not time is frozen
var frozen: bool = true
## The 1st card equipped
var equipcard1: Card
## The 2nd card equipped
var equipcard2: Card
## The 3rd card equipped
var equipcard3: Card
## The inventory. Should only contain [Card]s
var inventory: Array = []
## The kill count
var kills: int = 0
## The time elapsed
var time_elapsed: float = 0
## All of the buffs
var buffs: Dictionary = {
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


# TEMP
#func _ready():
	#inventory = [
		#snowball,
		#load("res://scene/resources/Data/Cards/Buffs/Attack.tres"),
		#load("res://scene/resources/Data/Cards/Buffs/Defense.tres"),
		#load("res://scene/resources/Data/Cards/Buffs/Health.tres"),
		#load("res://scene/resources/Data/Cards/Buffs/Speed.tres"),
		#load("res://scene/resources/Data/Cards/Buffs/Time.tres"),
		#load("res://scene/resources/Data/Cards/Weapons/Ice Axe.tres"),
		#load("res://scene/resources/Data/Cards/Weapons/Ice Pick.tres"),
		#load("res://scene/resources/Data/Cards/Weapons/Hot Grounds.tres")
	#]



## Changes frozen to true
func freeze():
	frozen = true

## Changes frozen to false
func unfreeze():
	frozen = false

## Sets the 1st equipped card
func set_equipcard1(new_card: Card):
	equipcard1 = new_card

## Gets the 1st equipped card
func get_equipcard1() -> Card:
	return equipcard1

## Sets the 2nd equipped card
func set_equipcard2(new_card: Card):
	equipcard2 = new_card

## Gets the 2nd equipped card
func get_equipcard2() -> Card:
	return equipcard2

## Sets the 3rd equipped card
func set_equipcard3(new_card: Card):
	equipcard3 = new_card

## Gets the 3rd equipped card
func get_equipcard3() -> Card:
	return equipcard3

## Sets all three equipped cards using an array
## Arrray: 1st [Card], 2nd [Card], 3rd [Card]
func set_equipped(new_equipment: Array):
	if new_equipment.size() != 3:
		return
	for item in new_equipment:
		if item and !(item is Card):
			return
	set_equipcard1(new_equipment[0])
	set_equipcard2(new_equipment[1])
	set_equipcard3(new_equipment[2])

## Gets all three equipped cards in the form of an array
func get_equipped() -> Array:
	return [equipcard1, equipcard2, equipcard3]

## Add a card to the inventory array
func add_to_inventory(new_card: Card):
	inventory.push_back(new_card)
	print(inventory)

## Remove a card from the inventory array via card
func remove_from_inventory_by_card(card: Card):
	if inventory.has(card):
		inventory.erase(card)
	else:
		print("Inventory does not contain " + card.name)

## Remove a card from the inventory array via index
func remove_from_inventory_by_index(index: int):
	if inventory.size() > index:
		inventory.pop_at(index)

## Get inventory array
func get_inventory() -> Array:
	return inventory

## Clear inventory
func clear_inventory() -> void:
	inventory = []

## Incrememnt the kill count
func increment_kills(count: int = 0):
	kills += count

## Gets the kill count
func get_kills() -> int:
	return kills

## Increments the time elapsed
func increment_time_elapsed(time: float = 0):
	time_elapsed += time

## Resets the time_elapsed
func reset_time_elapsed():
	time_elapsed = 0

## Gets the time elapsed
func get_time_elapsed() -> float:
	return time_elapsed


func update_buffs():
	buffs = {
		"health":1,
		"damage":1,
		"speed":1,
		"defense":1,
		"time":1,
	}
	for card in get_equipped():
		if card is Card and card != null:
			for key in card.effects.keys():
				buffs[key] += card.effects[key]


func get_card_enemy_data() -> Dictionary:
	return {
		"snowball": [FLYING_SKULL, BAT],
		"icepick": [ZOMBIE, YETI],
		"iceaxe": [WOLF, SNAKE],
		"hotgrounds": [SNOWMAN, SLIME]
	}
