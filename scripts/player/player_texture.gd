extends Sprite2D
class_name PlayerTexture

@export_node_path(AnimationPlayer)
var animation_path
@onready
var animation_obj : AnimationPlayer = get_node(animation_path)

@export_node_path(CharacterBody2D)
var player_path
@onready
var player_obj : CharacterBody2D    =    get_node(player_path)

var normal_attack:bool =    false
var suffix:String      = "_right"
var shield_off:bool    =    false
var crouching_off:bool =    false

func animation(direction:Vector2)->void:
	
	verify_position(direction)
	
	if player_obj.attacking or player_obj.defending or player_obj.crouching:
		print("DEBUG 1")
		actions_behavior()
	
	if direction.y != 0:
		vertical_behavior(direction)
	elif player_obj.landing == true:
		player_obj.set_physics_process(false)
		animation_obj.play("landing")
	else:
		horizontal_behavior(direction)
	
func actions_behavior():
	if player_obj.attacking and normal_attack:
		print("DEBUG 2 " + "attack"+suffix)
		animation_obj.play("attack"+suffix)
	if player_obj.defending and shield_off:
		print("DEBUG 3")
		animation_obj.play("shield")
		shield_off = true
	if player_obj.crouching and crouching_off:
		print("DEBUG 4")
		animation_obj.play("crouch")
		crouching_off = true

func verify_position(direction:Vector2)->void:
	if direction.x > 0:
		flip_h = false
		suffix = "_right"
	elif direction.x < 0:
		flip_h = true
		suffix = "_left"

func vertical_behavior(direction)->void:
	if direction.y > 0 :
		player_obj.landing = true
		animation_obj.play("fall")
	elif direction.y < 0 :
		animation_obj.play("jump")

func horizontal_behavior(direction)->void:
	if direction.x != 0:
		animation_obj.play("run")
	else :
		animation_obj.play("idle")


func _on_animation_finished(anim_name: String):
	match anim_name:
		"landing":
			player_obj.set_physics_process(true)
			player_obj.landing = false
		"attack_left":
			normal_attack = false
			player_obj.attacking = false
			player_obj.can_track_input = true
		"attack_right":
			normal_attack = false
			player_obj.attacking = false
			player_obj.can_track_input = true
