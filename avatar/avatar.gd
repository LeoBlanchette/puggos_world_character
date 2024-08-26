extends Node3D

## This Avatar class acts as a relay to sub-functionality, the main ones being the
## character animation and character appearance. The Avatar class / object as a 
## whole is meant to be agnostic to it's parent system, with the main controlling
## devices being in the Avatar parent (Character Controller).

class_name Avatar

@export var animation_tree: CharacterAnimationTree
@export var character_appearance: CharacterAppearance

var animations:Array[String]:
	get():
		return animation_tree.animations

#region movement control
var movement:Vector2:
	set(value):
		animation_tree.movement = value
	get():
		return animation_tree.movement
#endregion 

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
#endregion 

#region
## Plays a custom animation, not a base movement (builtin).
func play_animation(animation_name:String, body_region:String = "NONE", loop:bool = false)->void:
	animation_tree.play_animation(animation_name, body_region, loop)
#endregion

#region appearance
func equip(slot:String, path:String, meta=null):
	character_appearance.equip_slot(slot, path, meta)
#endregion
