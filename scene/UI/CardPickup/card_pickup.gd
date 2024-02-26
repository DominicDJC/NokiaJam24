extends Control

@export var pickup_sound: AudioStream
@export var away_sound: AudioStream
var picking_up_card: bool = false
var _is_put_away: bool = false
var allowing_input: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_sprite: TextureRect = $card


func _physics_process(delta: float) -> void:
	if allowing_input and Input.is_action_just_pressed("key_0"):
		_is_put_away = true
		allowing_input = false
		animation_player.stop()
		animation_player.play("put_away")
		await animation_player.animation_finished
		picking_up_card = false
		visible = false


func pickup(card: Card) -> void:
	Global.play_audio(pickup_sound)
	visible = true
	allowing_input = true
	picking_up_card = true
	_is_put_away = false
	card_sprite.texture = card.card_texture
	animation_player.play("card_pickup")
	await animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	if !_is_put_away:
		Global.play_audio(away_sound)
		_is_put_away = true
		allowing_input = false
		animation_player.play("put_away")
		await animation_player.animation_finished
		picking_up_card = false
		visible = false


func put_away() -> void:
	Global.play_audio(away_sound)
	_is_put_away = true
	allowing_input = false
	animation_player.stop()
	animation_player.play("put_away")
	await animation_player.animation_finished
	picking_up_card = false
	visible = false
