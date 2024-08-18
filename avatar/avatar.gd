extends Node3D

class_name Avatar

@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

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

func _physics_process(delta: float) -> void:
	movement_lerp_time += movement_lerp_speed * delta	
	movement_lerp_time = clamp(movement_lerp_time, 0, 1)
	if movement != Vector2.ZERO:
		animation_tree.set("parameters/Walking/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	else:
		animation_tree.set("parameters/Walking/blend_position", movement_last_value.lerp(Vector2.ZERO, movement_lerp_time))
