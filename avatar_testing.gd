extends Node3D

@export var avatar:Avatar
var blend_position:Vector2 
var is_crouching:bool = false
var is_combat_mode:bool = false
var is_moving:bool = false
var is_running:bool = false

func _physics_process(delta: float) -> void:
	blend_position = Vector2.ZERO
	is_running = false
	if Input.is_action_pressed("move_forward"):
		blend_position.y = 1
	if Input.is_action_pressed("move_backward"):
		blend_position.y = -1
	if Input.is_action_pressed("move_left"):
		blend_position.x = -1	
	if Input.is_action_pressed("move_right"):
		blend_position.x = 1
	if Input.is_action_pressed("shift"):
		is_running = true

	if blend_position == Vector2.ZERO:
		is_moving = false
	else:
		is_moving = true
	
	if Input.is_action_just_pressed("move_crouch"):
		is_crouching = !is_crouching
	if Input.is_action_just_pressed("tab"):
		is_combat_mode = !is_combat_mode
		
	avatar.is_crouching = is_crouching
	avatar.is_combat_mode = is_combat_mode
	avatar.is_running = is_running
	avatar.movement = blend_position

func _on_option_button_motion_states_item_selected(index: int) -> void:
	match index:
		0: # Default
			pass
		1: # Object: One Handed Slash
			pass
		2: # Object: Two Handed Slash
			pass
		3: # Object: One Handed Ranged
			pass
		4: # Object: Two Handed Ranged
			pass
		_: # Default
			pass

func _on_option_button_actions_item_selected(index: int) -> void:
	match index:
		0: # NONE
			pass
		1: # Punch Right
			pass
		2: # Punch Left
			pass
		3: # Kick Right
			pass
		4: # Kick Left
			pass
		_: # NONE
			pass
