class_name Weapon extends Node2D

signal ready_to_delete
@export var player: Player
@export var base_damage: int = 0
var can_delete: bool = true : set = _set_can_delete
var _is_deleting: bool = false


func attack_enemy(body: CharacterBody2D):
	if !(body is Player):
		body.hurt(base_damage * Global.buffs["damage"])


func delete(loadout: Node2D) -> void:
	if !_is_deleting:
		_is_deleting = true
		if !can_delete:
			await ready_to_delete
		loadout.remove_child(self)
		queue_free()


func _set_can_delete(new_value: bool) -> void:
	can_delete = new_value
	if can_delete:
		ready_to_delete.emit()
