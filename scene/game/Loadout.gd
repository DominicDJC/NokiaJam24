extends Node2D

@export var player: Player
var _equipment: Array = []

const HOTGROUNDS = preload("res://scene/weapons/hotgrounds/hotgrounds.tscn")
const ICEAXE = preload("res://scene/weapons/iceaxe/iceaxe.tscn")
const ICEPICK = preload("res://scene/weapons/icepick/icepick.tscn")
const SNOWBALL = preload("res://scene/weapons/snowball/snowball.tscn")


func _physics_process(delta: float) -> void:
	if _equipment != Global.get_equipped():
		_update_equipment()


func _update_equipment() -> void:
	_equipment = Global.get_equipped()
	Global.update_buffs()
	_clear_weapons()
	for card in _equipment:
		if card is Card and card.type == "weapon":
			_create_weapon(card)


func _clear_weapons() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()


func _create_weapon(card: Card) -> void:
	var weapon: Weapon
	match card.weapon:
		"snowball":
			weapon = SNOWBALL.instantiate()
		"icepick":
			weapon = ICEPICK.instantiate()
		"iceaxe":
			weapon = ICEAXE.instantiate()
		"hotgrounds":
			weapon = HOTGROUNDS.instantiate()
	if weapon:
		weapon.player = player
		add_child(weapon)
