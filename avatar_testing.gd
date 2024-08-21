extends Node3D

@export var avatar:Avatar
var blend_position:Vector2 
var is_crouching:bool = false
var is_combat_mode:bool = false
var is_moving:bool = false
var is_running:bool = false

#region UI/Menu options
@export var option_button_one_shots: OptionButton
@export var option_button_misc_loops: OptionButton 
@export var option_button_personalities: OptionButton 
#region 

func _ready() -> void:
	populate_test_animations()

func populate_test_animations():
	for animation:String in avatar.animations:
		if animation.to_lower().contains("oneshot_"):
			option_button_one_shots.add_item(animation)
		if animation.to_lower().contains("loop_"):
			option_button_misc_loops.add_item(animation)
		if animation.to_lower().contains("personality_"):
			option_button_misc_loops.add_item(animation)

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
			avatar.motion_state = "DEFAULT"
		1: # Object: One Handed Slash
			avatar.motion_state = "ONE_HANDED_SHARP"
		2: # Object: Two Handed BLUDGEON
			avatar.motion_state = "TWO_HANDED_BLUDGEON"
		3: # Object: One Handed Ranged
			avatar.motion_state = "RANGED_PISTOL"
		4: # Object: Two Handed Ranged
			avatar.motion_state = "RANGED_RIFLE"
		_: # Default
			avatar.motion_state = "DEFAULT"

func _on_option_button_one_shots_item_selected(index: int) -> void:
	var text:String = option_button_one_shots.get_item_text(index)
	avatar.play_animation(text)
	
func _on_option_button_misc_loops_item_selected(index: int) -> void:
	var text:String = option_button_misc_loops.get_item_text(index)
	avatar.play_animation(text)
	
func _on_option_button_personalities_item_selected(index: int) -> void:
	var text:String = option_button_personalities.get_item_text(index)
	avatar.play_animation(text)


func _on_option_button_affected_regions_item_selected(index: int) -> void:
	var affected_region:AnimationMerger.BodyRegion
	match index:
		0:
			affected_region = AnimationMerger.BodyRegion.NONE
		1: 
			affected_region = AnimationMerger.BodyRegion.FULL
		2: 
			affected_region = AnimationMerger.BodyRegion.HEAD
		3: 
			affected_region = AnimationMerger.BodyRegion.TORSO
		4: 
			affected_region = AnimationMerger.BodyRegion.LEGS
		_:
			affected_region = AnimationMerger.BodyRegion.NONE
	avatar.affected_body_region = affected_region
