class_name Weapon extends Node2D

@export var player: Player
@export var base_damage: int = 0


func attack_enemy(body: CharacterBody2D):
	if !(body is Player):
		body.hurt(base_damage * Global.buffs["damage"])
