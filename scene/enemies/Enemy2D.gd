class_name Enemy2D extends CharacterBody2D
## Base class for enemies. Contains health, damage, and movement functions, etc.
## Automatically attacks the player according to the cooldown

## Signals when hurting has stopped
signal hurting_stopped
## The type of enemy
@export var type: String
## The enemies animated sprite 2D
@export var animated_sprite: AnimatedSprite2D
## The maximum amount of health the enemy can have
@export var max_health: int = 10
## The amount of damage the enemy deals
@export var damage: int = 3
## The speed of the enemy
@export var speed: int = 5
## The time inbetween attacks
@export var attack_cooldown_start_time: int = 2
## The health object
var health: Health
## The player
var player: Player
## Whether or not the enemy currently contains the player
var contains_player: bool = false
## Whether or not the enemy is currently hurting
var hurting: bool = false : set = _set_hurting
## Whether or not the enemy is currently active
var active: bool = false
var _virtual_position: Vector2
var _attack_cooldown: float = 0.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _queue_free_cooldown: float = 15.0
var _visible_reset_cooldown: float = 5.0

const CARD = preload("res://scene/card/card.tscn")
const HEART = preload("res://scene/heart/heart.tscn")
const BLIP_4 = preload("res://assets/sound/blip4.wav")


func _ready() -> void:
	_rng.randomize()


func _physics_process(delta: float) -> void:
	if active:
		_physics()
		_animation()
		if _is_visible():
			_visible_reset_cooldown = 5.0
		else:
			_visible_reset_cooldown -= delta
			if _visible_reset_cooldown < 0:
				_virtual_position = _get_spawn_position()
				global_position = _virtual_position
				_visible_reset_cooldown = 5.0
	else:
		_queue_free_cooldown -= delta
		if _queue_free_cooldown < 0:
			get_parent().remove_child(self)
			queue_free()
	
	if !Global.frozen and active:
		_attack_cooldown -= delta
		if _attack_cooldown <= 0 and contains_player:
			player.hurt(damage, self)
			_attack_cooldown = attack_cooldown_start_time

## The initalizing script. Deactivates if active, assigns player,
## moves to spawn position, activates
func init(new_player: Player) -> void:
	if active:
		deactivate()
	player = new_player
	global_position = _get_spawn_position()
	_virtual_position = position
	activate()

## Hurts the enemy with the given damage
func hurt(damage):
	if active and !hurting:
		hurting = true
		health.hurt(damage)
		if health.get_health() <= 0:
			kill()
		Global.play_audio(BLIP_4)

## Kills the enemy. Incrementing kills and deactivating
func kill():
	await hurting_stopped
	Global.increment_kills()
	if _rng.randi_range(0, 1) == 0:
		_attempt_card()
	else:
		_attempt_heart()
	deactivate()

## Activates the enemy
func activate():
	health = Health.new(0, max_health)
	_attack_cooldown = attack_cooldown_start_time
	active = true
	#visible = true
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, true)
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)

## Deactivates the enemy
func deactivate():
	active = false
	visible = false
	set_collision_layer_value(2, false)
	set_collision_mask_value(2, false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)
	_queue_free_cooldown = 15.0

## A fixed move_and_slide function to deal with
## the low pixel count
func fixed_move_and_slide():
	global_position = _virtual_position
	move_and_slide()
	_virtual_position = global_position
	global_position = round(global_position)

## Flips the sprite according to velocity
func sprite_flipping(sprite: AnimatedSprite2D):
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func _set_hurting(new_value):
	hurting = new_value
	if !hurting:
		hurting_stopped.emit()


func _physics():
	visible = true
	if !player or Global.frozen:
		return
	var angle = global_position.angle_to_point(player.global_position)
	if hurting:
		velocity = Vector2(cos(angle), sin(angle))
		velocity = velocity * -40
	else:
		velocity = Vector2(cos(angle), sin(angle))
		velocity = velocity * speed
	fixed_move_and_slide()


func _animation():
	if Global.frozen:
		animated_sprite.pause()
	else:
		if hurting:
			if animated_sprite.animation != "hurt":
				animated_sprite.play("hurt")
			if !animated_sprite.is_playing():
				animated_sprite.play()
			if animated_sprite.frame == 3:
				hurting = false
		else:
			if animated_sprite.animation != "moving":
				animated_sprite.play("moving")
			if !animated_sprite.is_playing():
				animated_sprite.play()
			sprite_flipping(animated_sprite)


func _attempt_card() -> void:
	if _rng.randi_range(1, 5) == 1 or Global.kills_since_card > 14:
		var list_of_potential_cards: Array = []
		var card_counts: Dictionary = Global.card_counts
		for key in card_counts:
			if card_counts[key] + Global.world_card_counts[key] < 3:
				list_of_potential_cards.append(key)
		var type = list_of_potential_cards[_rng.randi_range(0, list_of_potential_cards.size() - 1)]
		_create_card(Global.cards[type])
		Global.reset_kills_since_card()


func _create_card(card: Card) -> void:
	var c = CARD.instantiate()
	c.init(card, global_position)
	Global.game.add_child(c)


func _attempt_heart() -> void:
	if _rng.randi_range(1, 5) == 1:
		var h = HEART.instantiate()
		h.init(global_position)
		Global.game.add_child(h)


func _get_spawn_position() -> Vector2:
	var player_position = player.global_position
	var spawn_position = Vector2(0, 0)
	match _rng.randi_range(0, 3):
		0: # above
			spawn_position.x = player_position.x + _rng.randi_range(-60, 60)
			spawn_position.y = player_position.y + 40
		1: # below
			spawn_position.x = player_position.x + _rng.randi_range(-60, 60)
			spawn_position.y = player_position.y - 40
		2: # right
			spawn_position.x = player_position.x + 60
			spawn_position.y = player_position.y + _rng.randi_range(-40, 40)
		3: # left
			spawn_position.x = player_position.x - 60
			spawn_position.y = player_position.y + _rng.randi_range(-40, 40)
	return spawn_position


func _is_visible() -> bool:
	var distance: Vector2 = Vector2(global_position.x - player.global_position.x, global_position.y - player.global_position.y)
	return !(abs(distance.x) > 50 or abs(distance.y) > 30)
