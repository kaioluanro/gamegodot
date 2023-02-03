extends CharacterBody2D
class_name Player

@onready 
var player_sprite: Sprite2D = get_node("Texture")

var velocity_player: Vector2

var jump_count: int = 0
var landing: bool   = false
var attacking: bool = false
var defending: bool = false
var crouching: bool = false

var can_track_input: bool = true

@export_category("Player Run")
@export
var speed : int

@export_category("Player Jump")
@export
var jump_speed: int
@export
var player_gravity: int

func _physics_process(delta:float):
	hozizontal_movement_env()
	vertical_movement_env()
	actions_env()
	
	gravity(delta)
	move_and_slide()
	player_sprite.animation(velocity)

func hozizontal_movement_env()->void:
	var input : float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if can_track_input == false or attacking:
		velocity.x = 0
		return
	velocity.x = input * speed

func vertical_movement_env()->void:
	if is_on_floor():
		jump_count = 0
	
	if Input.is_action_just_pressed("ui_select") and jump_count < 2 and can_track_input and not attacking:
		jump_count += 1
		velocity.y = jump_speed
	
func gravity(delta:float)->void:
	velocity.y += delta * player_gravity
	if velocity.y >= player_gravity:
		velocity.y = player_gravity

func actions_env()->void:
	attack()
	defend()
	crouch()

func attack()->void:
	var attack_condition: bool = not attacking and not defending and not crouching
	
	if Input.is_action_just_released("attack") and attack_condition and is_on_floor():
		attacking = true
		player_sprite.normal_attack = true
	
func defend()->void:
	if Input.is_action_pressed("defend") and not crouching and is_on_floor():
		defending = true
		crouching = false
		can_track_input = false
	elif not crouching:
		defending = false
		can_track_input = true
		player_sprite.shield_off = true
	
func crouch()->void:
	if Input.is_action_pressed("crouch") and not defending and is_on_floor():
		crouching = true
		can_track_input = false
	elif not defending:
		crouching = false
		can_track_input = true
		player_sprite.crouching_off = true
		
