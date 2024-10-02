@tool
extends SkeletonModifier3D

## Joins animations to the avatar according to body regions.
## Created due to requirement for modding and limitations in AnimationTree system.
class_name AnimationMerger

const skel_path:String = "Armature/Skeleton3D:"

@export var animation_player: AnimationPlayer 
@export var character_animation_tree: CharacterAnimationTree 

#region bone lists
var bone_list:Array[String]
@export var head:Array[String]
@export var torso:Array[String]
@export var legs:Array[String]
var temporary_track_index:Dictionary = {}
#endregion 

#region animation areas
enum BodyRegion{
	NONE,
	FULL,
	HEAD,
	TORSO,
	LEGS,
	HEAD_TORSO,
}
## currently affected body region
var body_region:BodyRegion = BodyRegion.NONE:
	set(value):
		body_region = value
		set_affected_body_region(value)

## list of bones of currently affected body region
var affected_body_region:Array[String]
#endregion 

#region influence blending / fading.
enum InfluenceFadeMode{
	NONE,
	FADE_IN,
	FADE_OUT,
}
signal fade_in_complete()
signal fade_out_complete()
var elapsed_fade_time:float = 0
var fade_time:float = 0.33
var influence_fade_mode = InfluenceFadeMode.NONE
#endregion 

#region head control
@onready var head_look_at_control: BoneAttachment3D = $"../HeadLookAtControl"
var head_bone_idx:int = 0
var neck_bone_idx:int = 0
#endregion

#region builtins
func _ready() -> void:
	populate_bone_list()
	head_bone_idx = get_skeleton().find_bone("Head")
	neck_bone_idx = get_skeleton().find_bone("Spine_5")

func _process(delta: float) -> void:
	process_fade(delta)
	

## We are using this to merge modded animations into the animation process.
## At this time in Godot (Aug 2024) it seems to be the only way.
## https://godotengine.org/article/design-of-the-skeleton-modifier-3d/ 
func _process_modification() -> void:
	var skeleton: Skeleton3D = get_skeleton()
	if !skeleton:
		return # Never happen, but for the safety.
	if not animation_player.current_animation.is_empty():
		var current_animation = animation_player.current_animation		
		var animation:Animation = animation_player.get_animation(current_animation)
		if temporary_track_index.is_empty():
			set_temporary_track_index(animation)
		merge_current_running_animation(skeleton, animation)
	else:
		temporary_track_index.clear()
	
#endregion

## Initially populates relevant bones to check against. We do this because it 
## will iterate over all bones each _process_modification call. So we reduce 
## the amount of bones checked against to only the animated ones. 
func populate_bone_list():
	bone_list = head + torso + legs
	
## Sets the bone name / track index of the playing animation. Fires once 
## when a custom animation is played.
func set_temporary_track_index(animation:Animation):
	var c:int = animation.get_track_count()
	for i in range(c):
		var t_path:String = animation.track_get_path(i)
		var bone_name:String = t_path.replace(skel_path, "")
		if not temporary_track_index.has(bone_name):
			if bone_name in bone_list:
				temporary_track_index[bone_name] = i

func set_affected_body_region(region:BodyRegion = BodyRegion.FULL, _trim:BodyRegion = BodyRegion.NONE):

	match region:
		BodyRegion.NONE:
			affected_body_region = []
		BodyRegion.FULL:
			affected_body_region = head+torso+legs
		BodyRegion.HEAD:
			affected_body_region = head
		BodyRegion.TORSO:
			affected_body_region = torso
		BodyRegion.LEGS:
			affected_body_region = legs
		BodyRegion.HEAD_TORSO:
			affected_body_region = head+torso

func merge_current_running_animation(skeleton: Skeleton3D, animation:Animation):
	var time:float = animation_player.current_animation_position

	for bone in temporary_track_index:	
		if not bone in affected_body_region:
			continue
		var idx:int = temporary_track_index[bone]

		var rot:Quaternion = get_rotation_at_time(bone, animation, time)
		var pos:Vector3 = get_position_at_time(bone, animation, time)
		var sca:Vector3 = get_scale_at_time(bone, animation, time)
		
		var bone_idx: int = skeleton.find_bone(bone)
		if rot != Quaternion.IDENTITY:
			skeleton.set_bone_pose_rotation(bone_idx, rot)
		if pos != Vector3.ZERO:
			skeleton.set_bone_pose_position(bone_idx, pos)
		if sca != Vector3.ZERO:
			skeleton.set_bone_pose_scale(bone_idx, pos)

func get_rotation_at_time(bone:String, animation:Animation, time:float)->Quaternion:
		var track_idx:int = animation.find_track(skel_path+bone, Animation.TYPE_ROTATION_3D)
		if track_idx == -1:
			return Quaternion.IDENTITY
		var rot:Quaternion = animation.rotation_track_interpolate(track_idx, time)
		return rot 
	
func get_position_at_time(bone:String, animation:Animation, time:float)->Vector3:
		var track_idx:int = animation.find_track(skel_path+bone, Animation.TYPE_POSITION_3D)
		if track_idx == -1:
			return Vector3.ZERO
		var pos:Vector3 = animation.position_track_interpolate(track_idx, time)
		return pos 
		
func get_scale_at_time(bone:String, animation:Animation, time:float)->Vector3:
		var track_idx:int = animation.find_track(skel_path+bone, Animation.TYPE_SCALE_3D)
		if track_idx == -1:
			return Vector3.ZERO		
		var sca:Vector3 = animation.scale_track_interpolate(track_idx, time)
		return sca 
		
#region process influence blending / fading.
func process_fade(delta:float)->void:
	elapsed_fade_time += delta
	match influence_fade_mode:
		InfluenceFadeMode.FADE_IN:
			influence = clampf((1/fade_time)*elapsed_fade_time, 0, 1)
		InfluenceFadeMode.FADE_OUT:
			influence = clampf(1-(1/fade_time)*elapsed_fade_time, 0, 1)
	if elapsed_fade_time >= fade_time:
		cancel_fade()

func do_influence_fade_in():
	if influence_fade_mode == InfluenceFadeMode.FADE_IN:
		return
	elapsed_fade_time = 0
	influence_fade_mode = InfluenceFadeMode.FADE_IN
	set_process(true)
	
func do_influence_fade_out(delay:float = 0):
	if influence_fade_mode == InfluenceFadeMode.FADE_OUT:
		return
	await  get_tree().create_timer(delay).timeout
	elapsed_fade_time = 0
	influence_fade_mode = InfluenceFadeMode.FADE_OUT
	set_process(true)

func cancel_fade():
	elapsed_fade_time = 0
	influence_fade_mode = InfluenceFadeMode.NONE
	influence = 1
	set_process(false)
	
#endregion 

#region head movement
func enable_head_look(enabled:bool = true):
	head_look_at_control.override_pose = enabled
	
func head_look_at(pos:Vector3):
	var skeleton: Skeleton3D = get_skeleton()
	if !skeleton:
		return # Never happen, but for the safety.
	var neck_transform:Transform3D = skeleton.get_bone_global_pose(neck_bone_idx)
	var neck_anchor_point:Vector3 = neck_transform.origin+neck_transform.basis.y * 0.055844 
	head_look_at_control.position = neck_anchor_point
	head_look_at_control.look_at(pos, Vector3.UP, true)	


#endregion
