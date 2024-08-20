extends Node3D

## This Avatar class acts as a relay to sub-functionality, the main ones being the
## character animation and character appearance. The Avatar class / object as a 
## whole is meant to be agnostic to it's parent system, with the main controlling
## devices being in the Avatar parent.

class_name Avatar

@export var animation_tree: CharacterAnimationTree

#region movement control
var movement:Vector2:
	set(value):
		animation_tree.movement = value
	get():
		return animation_tree.movement
#region 

#region motion states
var motion_state:String:
	set(value):	
		animation_tree.motion_state = value
	get():
		return animation_tree.motion_state
		
var is_moving:bool:
	set(value):
		animation_tree.is_moving = value
	get():
		return animation_tree.is_moving
		
var is_crouching:bool:
	set(value):
		animation_tree.is_crouching = value
	get():
		return animation_tree.is_crouching

var is_combat_mode:bool:
	set(value):
		animation_tree.is_combat_mode = value
	get():
		return animation_tree.is_combat_mode

var is_running:bool:
	set(value):
		is_running = value
		animation_tree.is_running = value
	get():
		return animation_tree.is_running
#region 

func _physics_process(delta: float) -> void:
	animation_tree.update_movement_blend_positions(delta)
	
func do_punch_right():
	pass
func do_punch_left():
	pass
func do_kick_right():
	pass
func do_kick_left():
	pass


		
