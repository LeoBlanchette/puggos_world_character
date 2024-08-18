extends Node3D

@export var avatar:Avatar
var blend_position:Vector2 
var is_crouching:bool = false
func _physics_process(delta: float) -> void:
	blend_position = Vector2.ZERO
	if Input.is_action_pressed("move_forward"):
		blend_position.y = 1
	if Input.is_action_pressed("move_backward"):
		blend_position.y = -1
	if Input.is_action_pressed("move_left"):
		blend_position.x = -1	
	if Input.is_action_pressed("move_right"):
		blend_position.x = 1
		
	if Input.is_action_just_pressed("move_crouch"):
		is_crouching = !is_crouching
	
	avatar.is_crouching = is_crouching
	avatar.movement = blend_position
