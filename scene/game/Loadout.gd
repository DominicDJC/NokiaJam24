extends Node2D

@export var player: Player
var _equipment: Array = []
var _weapon_counts: Dictionary = {
	"snowball":0,
	"iceaxe":0,
	"icepick":0,
	"hotgrounds":null,
}

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
		child.delete(self)
	_weapon_counts = {
		"snowball":0,
		"iceaxe":0,
		"icepick":0,
		"hotgrounds":null,
	}


func _create_weapon(card: Card) -> void:
	var weapon: Weapon
	match card.weapon:
		"snowball":
			weapon = SNOWBALL.instantiate()
			weapon._rotation_speed *= _weapon_counts["snowball"] + 1
		"icepick":
			weapon = ICEPICK.instantiate()
			if _weapon_counts["icepick"] > 0:
				weapon._cooldown -= _weapon_counts["icepick"] * 0.2
		"iceaxe":
			weapon = ICEAXE.instantiate()
			if _weapon_counts["iceaxe"] > 0:
				weapon._cooldown -= _weapon_counts["iceaxe"] * 0.4
		"hotgrounds":
			if !_weapon_counts["hotgrounds"]:
				weapon = HOTGROUNDS.instantiate()
				_weapon_counts["hotgrounds"] = weapon
			else:
				_weapon_counts["hotgrounds"].wait_time -= .3
	if weapon:
		if !card.weapon == "hotgrounds":
			_weapon_counts[card.weapon] += 1
		weapon.player = player
		add_child(weapon)
