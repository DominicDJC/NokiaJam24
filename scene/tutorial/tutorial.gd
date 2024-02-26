extends Control

signal done
var index = 1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("key_0"):
		Global.ui_sound()
		index += 1
		if index > get_child_count() - 2:
			index -= 1
			done.emit()
	
	for child in get_children():
		if child.name == str(index) or child.name == "Continue":
			child.visible = true
		else:
			child.visible = false
