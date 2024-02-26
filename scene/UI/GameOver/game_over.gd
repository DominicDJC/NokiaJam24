extends Control

signal done
var _locked = true


func _ready() -> void:
	await get_tree().create_timer(.05).timeout
	_locked = false


func _process(delta: float) -> void:
	if !_locked and Input.is_action_just_pressed("key_0"):
		Global.ui_sound()
		done.emit()
