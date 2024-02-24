class_name Enemy2D extends CharacterBody2D
## Base class for enemies. Contains health, damage, and movement functions, etc.
## Automatically attacks the player according to the cooldown

## Signals when hurting has stopped
signal hurting_stopped
## The enemies animated sprite 2D
@export var animated_sprite: AnimatedSprite2D
## The maximum amount of health the enemy can have
@export var max_health: int = 10
## The amount of damage the enemy deals
@export var damage: int = 1
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


func _physics_process(delta: float) -> void:
	if active:
		_physics()
		_animation()
	
	if !Global.frozen and active:
		_attack_cooldown -= delta
		if _attack_cooldown <= 0 and contains_player:
			player.hurt(damage)
			_attack_cooldown = attack_cooldown_start_time

## The initalizing script. Deactivates if active, assigns player,
## moves to spawn position, activates
func init(new_player: Player, new_position: Vector2) -> void:
	if active:
		deactivate()
	player = new_player
	global_position = new_position
	_virtual_position = position
	activate()

## Hurts the enemy with the given damage
func hurt(damage):
	if active:
		hurting = true
		health.hurt(damage)
		if health.get_health() <= 0:
			kill()
	print(health.get_health())

## Kills the enemy. Incrementing kills and deactivating
func kill():
	await hurting_stopped
	Global.increment_kills()
	deactivate()

## Activates the enemy
func activate():
	health = Health.new(0, max_health)
	_attack_cooldown = attack_cooldown_start_time
	active = true
	visible = true

## Deactivates the enemy
func deactivate():
	active = false
	visible = false

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
