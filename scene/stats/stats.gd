extends Control

signal done
var _locked: bool = true

func _ready() -> void:
	$VBoxContainer/Time.text = "TIME ELAPSED:\n" + _get_time()
	$VBoxContainer/Kills.text = "ENEMIES KILLED:\n" + str(Global.get_kills())
	await get_tree().create_timer(.05).timeout
	_locked = false


func _process(delta: float) -> void:
	if !_locked and Input.is_action_just_pressed("key_0"):
		Global.ui_sound()
		done.emit()


func _get_time() -> String:
	var time = Global.time_elapsed
	if time == 0:
		time += 1
	var minutes = int(time / 60)
	var seconds = int(time - (minutes * 60))
	var seconds_string = str(seconds)
	if seconds_string.length() == 1:
		seconds_string = "0" + seconds_string
	return str(minutes) + ":" + seconds_string
