extends Control

signal start_game

@export var music: AudioStream

var in_intro: bool = true
var started: bool = false

@onready var intro_anim_player = $Intro/AnimationPlayer


func _ready() -> void:
	Global.play_audio(music)


func _process(_delta):
	if not in_intro and not started:
		if Input.is_action_just_pressed("key_0"):
			Global.stop_audio()
			started = true
			intro_anim_player.play("transition")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "intro":
		in_intro = false
		
	elif anim_name == "transition":
		start_game.emit()
