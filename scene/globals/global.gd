extends Node

# Starting card
#var snowball = preload("res://scene/resources/Data/Cards/Weapons/Snowball.tres")

## The game Node2D
var game: Node2D
## Whether or not time is frozen
var frozen: bool = false
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
## Kills since the last card
var kills_since_card: int = 0
## All of the buffs
var buffs: Dictionary = {
	"health":0,
	"damage":0,
	"speed":0,
	"defense":0,
	"time":0,
}
## The card counts
var card_counts: Dictionary = {
	"Attack Up": 0,
	"Shield Up": 0,
	"Health Up": 0,
	"Speed Up": 0,
	#"Slow Time": 0,
	"Hot Grounds": 0,
	"Ice Axe": 0,
	"Ice Pick": 0,
	"Snowball": 0,
}
## The card count on the map
var world_card_counts: Dictionary = {
	"Attack Up": 0,
	"Shield Up": 0,
	"Health Up": 0,
	"Speed Up": 0,
	#"Slow Time": 0,
	"Hot Grounds": 0,
	"Ice Axe": 0,
	"Ice Pick": 0,
	"Snowball": 0,
}
var audio: AudioStreamPlayer = AudioStreamPlayer.new()

const BAT = preload("res://scene/resources/Data/Enemies/Bat.tres")
const FLYING_SKULL = preload("res://scene/resources/Data/Enemies/FlyingSkull.tres")
const SLIME = preload("res://scene/resources/Data/Enemies/Slime.tres")
const SNAKE = preload("res://scene/resources/Data/Enemies/Snake.tres")
const SNOWMAN = preload("res://scene/resources/Data/Enemies/Snowman.tres")
const WOLF = preload("res://scene/resources/Data/Enemies/Wolf.tres")
const YETI = preload("res://scene/resources/Data/Enemies/Yeti.tres")
const ZOMBIE = preload("res://scene/resources/Data/Enemies/Zombie.tres")

const cards: Dictionary = {
	"Attack Up": preload("res://scene/resources/Data/Cards/Buffs/Attack.tres"),
	"Shield Up": preload("res://scene/resources/Data/Cards/Buffs/Defense.tres"),
	"Health Up": preload("res://scene/resources/Data/Cards/Buffs/Health.tres"),
	"Speed Up": preload("res://scene/resources/Data/Cards/Buffs/Speed.tres"),
	"Slow Time": preload("res://scene/resources/Data/Cards/Buffs/Time.tres"),
	"Hot Grounds": preload("res://scene/resources/Data/Cards/Weapons/Hot Grounds.tres"),
	"Ice Axe": preload("res://scene/resources/Data/Cards/Weapons/Ice Axe.tres"),
	"Ice Pick": preload("res://scene/resources/Data/Cards/Weapons/Ice Pick.tres"),
	"Snowball": preload("res://scene/resources/Data/Cards/Weapons/Snowball.tres"),
}

const C_5 = preload("res://assets/sound/C5.wav")


func _ready() -> void:
	add_child(audio)


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
	card_counts[new_card.name] += 1

## Remove a card from the inventory array via card
func remove_from_inventory_by_card(card: Card):
	if inventory.has(card):
		inventory.erase(card)
		card_counts[card.name] -= 1
	else:
		print("Inventory does not contain " + card.name)

## Remove a card from the inventory array via index
func remove_from_inventory_by_index(index: int):
	if inventory.size() > index:
		card_counts[inventory[index].name] -= 1
		inventory.pop_at(index)

## Get inventory array
func get_inventory() -> Array:
	return inventory

## Clear inventory
func clear_inventory() -> void:
	inventory = []

## Incrememnt the kill count
func increment_kills(count: int = 1):
	kills += count
	kills_since_card += 1

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


func reset_kills_since_card() -> void:
	kills_since_card = 0


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


func play_audio(track: AudioStream) -> void:
	stop_audio()
	audio.stream = track
	audio.play()


func stop_audio() -> void:
	audio.stop()


func ui_sound() -> void:
	play_audio(C_5)
