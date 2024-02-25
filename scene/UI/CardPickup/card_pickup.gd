extends Control

var picking_up_card: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_sprite: TextureRect = $card


func pickup(card: Card) -> void:
	picking_up_card = true
	card_sprite.texture = card.card_texture
	animation_player.play("card_pickup")
	await animation_player.animation_finished
	await get_tree().create_timer(1).timeout
	animation_player.play("put_away")
	await animation_player.animation_finished
	picking_up_card = false
