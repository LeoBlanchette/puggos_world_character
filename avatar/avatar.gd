extends Node3D

## This Avatar class acts as a relay to sub-functionality, the main ones being the
## character animation and character appearance. The Avatar class / object as a 
## whole is meant to be agnostic to it's parent system, with the main controlling
## devices being in the Avatar parent.

class_name Avatar

@export var animation_tree: CharacterAnimationTree

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
## This applies to secondary animations layered on top of primary core animations.
## Limits animation to a particular body region so that the avatar can mutitask,
## such as eating while running.
var affected_body_region:AnimationMerger.BodyRegion:
	set(value):
		affected_body_region = value
		animation_tree.animation_merger.body_region = value
	get():
		return animation_tree.animation_merger.body_region
#endregion

func _physics_process(delta: float) -> void:
	animation_tree.update_movement_blend_positions(delta)

func play_animation(animation_name:String)->void:
	animation_tree.play_animation(animation_name)
