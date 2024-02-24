class_name Weapon extends Node2D

@export var player: Player
@export var base_damage: int = 0
var _additional_damage: int = 0
var _frozen_save: bool = true


func _physics_process(delta):
	if _frozen_save != Global.frozen:
		_frozen_save == Global.frozen
		if !_frozen_save:
			_update_additional_damage()


func _update_additional_damage():
	_additional_damage = 0
	var equipped_cards = Global.get_equipped()
	for card in equipped_cards:
		_additional_damage += card.effects["damage"]


func attack_enemy(body: CharacterBody2D):
	if !(body is Player):
		body.hurt(base_damage + _additional_damage)
