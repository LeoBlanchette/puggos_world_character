extends AnimationTree


class_name CharacterAnimationTree

enum BaseMotionState{
	DEFAULT,
	SNEAK,
	RUN,
}

enum AlteredMotionState{
	DEFAULT,
	RANGED_PISTOL,
	RANGED_RIFLE,
	TWO_HANDED_BLUDGEON,
	ONE_HANDED_SHARP,
}

var motion_state:String:
	set(value):
		motion_state = value
		set_general_motion_state(value)
	get():
		return motion_state

var base_motion_state:BaseMotionState = BaseMotionState.DEFAULT:
	set(value):
		if base_motion_state == value: 
			return #because we do not need to set motion state if it hasn't changed.
		base_motion_state = value
		set_motion_state()

var altered_motion_state:AlteredMotionState = AlteredMotionState.DEFAULT:
	set(value):
		if altered_motion_state == value:
			return #because we do not need to set motion state if it hasn't changed.
		altered_motion_state = value
		set_motion_state()

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

#region motion states
var is_moving:bool = false:
	set(value):
		if is_moving == value:
			return
		is_moving = value
		set_motion_base_state()
		
var is_crouching:bool = false:
	set(value):
		if is_crouching == value:
			return
		is_crouching = value
		set_motion_base_state()
		
var is_combat_mode:bool = false:
	set(value):
		if is_combat_mode == value:
			return
		is_combat_mode = value
		set_motion_base_state()
		
var is_running:bool = false:
	set(value):
		if is_running == value:
			return
		is_running = value
		set_motion_base_state()
#region 

func update_movement_blend_positions(delta:float):
	movement_lerp_time += movement_lerp_speed * delta	
	movement_lerp_time = clamp(movement_lerp_time, 0, 1)
	
	# DEFAULT MOTION
	set("parameters/MovementDefault/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	set("parameters/MovementDefaultSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	set("parameters/MovementRun/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	# ONE HANDED SHARP ALTERED MOTION
	set("parameters/MovementOneHandedSharp/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	set("parameters/MovementOneHandedSharpSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	# RANGED PISTOL ALTERED MOTION
	set("parameters/MovementRangedPistol/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	set(" parameters/MovementRangedPistolSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	# MOVEMENT_RANGE RIFLE ALTERED MOTION
	set("parameters/MovementRangedRifle/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	set("parameters/MovementRangedRifleSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	# MOVMENT TWO HANDED BLUDGEON ALTERED MOTION
	set("parameters/MovementTwoHandedBludgeon/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	set("parameters/MovementTwoHandedBludgeonSneak/blend_position", movement_last_value.lerp(movement, movement_lerp_time))
	
	if movement == Vector2.ZERO:
		is_moving = false
	else:
		is_moving = true
	
## Sets the base motion state based on existing boolean conditions such as
## is_running, is_crouching
func set_motion_base_state():
		
	if !is_moving && !is_crouching: #not moving, so default
		base_motion_state = BaseMotionState.DEFAULT
		return 
		
	if !is_running && !is_crouching: #not running or crouching, so we are walking, default
		base_motion_state = BaseMotionState.DEFAULT
		return
		
	if is_crouching: #if we are crouching, we cannot run
		base_motion_state = BaseMotionState.SNEAK
		return
	
	if is_running: #we can run since other condition allows
		base_motion_state = BaseMotionState.RUN

## General function for setting the base motion state according to the two the 
## two main base motion enums: BaseMotionState and AlteredMotionState
func set_motion_state():
	match base_motion_state:
		BaseMotionState.DEFAULT:
			set_to_default()
		BaseMotionState.SNEAK:
			set_to_sneak()
		BaseMotionState.RUN:
			set_to_run()
		_:
			pass
			
	match altered_motion_state:
		AlteredMotionState.DEFAULT:
			#set_to_default()
			pass
		AlteredMotionState.RANGED_PISTOL:
			set("parameters/AlteredMotionStates/transition_request", "ranged_pistol")
		AlteredMotionState.RANGED_RIFLE:
			set("parameters/AlteredMotionStates/transition_request", "ranged_rifle")
		AlteredMotionState.TWO_HANDED_BLUDGEON:
			set("parameters/AlteredMotionStates/transition_request", "two_handed_bludgeon")
		AlteredMotionState.ONE_HANDED_SHARP:
			set("parameters/AlteredMotionStates/transition_request", "one_handed_sharp")
		_:
			pass
			#set_to_default()


func set_to_default():
	print("DEFAULT")
	set("parameters/WalkSneakTransition/transition_request", "walk")
	set("parameters/DefaultRunTransition/transition_request", "default")

func set_to_sneak():
	set("parameters/WalkSneakTransition/transition_request", "sneak")
	set("parameters/DefaultRunTransition/transition_request", "default")

func set_to_run():	
	set("parameters/WalkSneakTransition/transition_request", "walk")
	set("parameters/DefaultRunTransition/transition_request", "run")

func set_general_motion_state(motion_state:String)->void:
	
	if BaseMotionState.has(motion_state):
		base_motion_state = BaseMotionState.get(motion_state)
	if AlteredMotionState.has(motion_state):
		altered_motion_state = AlteredMotionState.get(motion_state)
