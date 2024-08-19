extends Node3D

class_name Avatar

@export var animation_player: AnimationPlayer
@export var animation_tree: CharacterAnimationTree

#region movement control
## This movement pertains to the default WASD controls.
var movement:Vector2:
	set(value):
		if value != movement:
			movement_last_value = movement
			movement_lerp_time = 0
		movement = value

@export var movement_lerp_speed:float = 1
var movement_lerp_time:float
var movement_last_value:Vector2
#endregion 

#region states
var is_moving:bool = false:
	set(value):
		is_moving = value
		set_tree_state()
		
var is_crouching:bool = false:
	set(value):
		is_crouching = value
		set_tree_state()
		
var is_combat_mode:bool = false:
	set(value):
		is_combat_mode = value
		set_tree_state()
#region 

func _physics_process(delta: float) -> void:
	update_movement_blend_positions(delta)

## Updates all of the movement blends.
func update_movement_blend_positions(delta:float):
	movement_lerp_time += movement_lerp_speed * delta	
	movement_lerp_time = clamp(movement_lerp_time, 0, 1)
	
	animation_tree.set("parameters/MovementDefault/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	animation_tree.set("parameters/MovementDefaultSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	animation_tree.set("parameters/MovementOneHandedSharp/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	animation_tree.set("parameters/MovementOneHandedSharpSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	animation_tree.set("parameters/MovementRangedPistol/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	animation_tree.set(" parameters/MovementRangedPistolSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	animation_tree.set("parameters/MovementRangedRifle/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	animation_tree.set("parameters/MovementRangedRifleSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	animation_tree.set("parameters/MovementTwoHandedBludgeon/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	animation_tree.set("parameters/MovementTwoHandedBludgeonSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))

func set_tree_state():
	pass
		
