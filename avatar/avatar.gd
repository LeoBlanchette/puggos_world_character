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

#region animation
func get_character_animation_library()->AnimationLibrary:
	return animation_tree.get_animation_library("Character") 

## Adds an animation to the Character animation library from it's path.
## Useful for modding.
func add_animation(path:String):
	var animation_library:AnimationLibrary = get_character_animation_library()
	if not FileAccess.file_exists(path):
		print("Animation does not exist at: %s"%path)
		return	
	var animation:Animation = load(path)
	if not animation_library.has_animation(animation.resource_name):
		animations.append(animation.resource_name)
		animation_library.add_animation(animation.resource_name, animation)

## Removes an animation from avatar according to it's rsource path
func remove_animation_by_path(path:String):
	var animation:Animation = load(path)
	var animation_name:String = animation.resource_name
	remove_animation(animation_name)

## Removes an animation from avatar according to it's name
func remove_animation(animation_name:String):
	animations.erase(animation_name)
	var animation_library:AnimationLibrary = get_character_animation_library()
	animation_library.remove_animation(animation_name)

## Plays a custom animation, not a base movement (builtin).
func play_animation(animation_name:String, body_region:String = "NONE", loop:bool = false)->void:
	animation_tree.play_animation(animation_name, body_region, loop)
#endregion

#region appearance
func equip(slot:String, path:String, meta=null):
	character_appearance.equip_slot(slot, path, meta)

#endregion
