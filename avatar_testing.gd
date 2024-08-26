extends Node3D
## This is a testing scene script for the avatar. It is not meant to be 
## used in game.
class_name AvatarTestingUI

static var instance:AvatarTestingUI

@export var avatar:Avatar
var blend_position:Vector2 
var is_crouching:bool = false
var is_combat_mode:bool = false
var is_moving:bool = false
var is_running:bool = false
var affected_body_region:String = "NONE"

#region UI/Menu options
var ui_blocking:bool = false
@export var option_button_one_shots: OptionButton
@export var option_button_misc_loops: OptionButton 
@export var option_button_personalities: OptionButton 
 
@export var v_box_container_motion: VBoxContainer
@export var v_box_container_appearance: VBoxContainer
var slot_options:Dictionary = {}
#region 

#region paths
const TEST_OBJECTS_PATH:String = "res://addons/puggos_world_character/test_objects/"
#endregion 

func _ready() -> void:
	if instance == null:
		instance = self
	else:
		queue_free()
	populate_test_animations()
	populate_slot_option_buttons()
	populate_test_appearance_skins()
	populate_test_appearance_rigged_objects()
	show_motion_options()


func _exit_tree() -> void:
	if instance != null:
		instance = null

func populate_slot_option_buttons():
	for child in v_box_container_appearance.get_children():
		if child.name.to_lower().contains("slot_"):
			var option_button:OptionButton = child
			slot_options[option_button.name.to_upper()] = option_button
			option_button.add_item("-")

func populate_test_appearance_skins():
	for x in range(3):
		var folder:String = "%sslot_%s/"%[TEST_OBJECTS_PATH, str(x+1)]
		var objects:Array = HelperFunctions.get_all_files(folder, "png")
		if not objects.is_empty():
			for path:String in objects:
				path = path.replace(TEST_OBJECTS_PATH, "")
				create_slot_ui_entry(x+1, path)

func populate_test_appearance_rigged_objects():
	var allowed_extensions:Array[String] = ["gltf", "glb"]
	for ext:String in allowed_extensions:
		for x in range(34):
			if x < 2:
				continue ## skip the skin texture slots.
			var folder:String = "%sslot_%s/"%[TEST_OBJECTS_PATH, str(x+1)]
			var objects:Array = HelperFunctions.get_all_files(folder, ext)
			if not objects.is_empty():
				for path:String in objects:
					if "/misc/" in path:
						continue
					
					path = path.replace(TEST_OBJECTS_PATH, "")
					create_slot_ui_entry(x+1, path)

func create_slot_ui_entry(slot:int, path:String):
	if path.ends_with(".import"):
		return
	if path.ends_with(".txt"):
		return
	##Create dropdown button entry in corresponding slot number
	var dropdown:OptionButton = slot_options["SLOT_%s"%str(slot)]
	dropdown.add_item(path)

func populate_test_animations():
	for animation:String in avatar.animations:
		if animation.to_lower().contains("oneshot_"):
			option_button_one_shots.add_item(animation)
		if animation.to_lower().contains("loop_"):
			option_button_misc_loops.add_item(animation)
		if animation.to_lower().contains("personality_"):			
			option_button_personalities.add_item(animation)

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
	avatar.play_animation(text, affected_body_region)
	
func _on_option_button_misc_loops_item_selected(index: int) -> void:
	var text:String = option_button_misc_loops.get_item_text(index)
	avatar.play_animation(text, affected_body_region, true)
	
func _on_option_button_personalities_item_selected(index: int) -> void:
	var text:String = option_button_personalities.get_item_text(index)
	avatar.play_animation(text, affected_body_region, true)


func _on_option_button_affected_regions_item_selected(index: int) -> void:
	var body_region:AnimationMerger.BodyRegion = AnimationMerger.BodyRegion.NONE
	match index:
		0:
			body_region = AnimationMerger.BodyRegion.NONE
		1: 
			body_region = AnimationMerger.BodyRegion.FULL
		2: 
			body_region = AnimationMerger.BodyRegion.HEAD
		3: 
			body_region = AnimationMerger.BodyRegion.TORSO
		4: 
			body_region = AnimationMerger.BodyRegion.LEGS
		_:
			body_region = AnimationMerger.BodyRegion.NONE
	affected_body_region = AnimationMerger.BodyRegion.keys()[body_region]


func _on_button_motion_test_pressed() -> void:
	show_motion_options()


func _on_button_appearance_test_pressed() -> void:
	show_appearance_options()

func show_motion_options():
	v_box_container_appearance.hide()
	v_box_container_motion.show()
	
func show_appearance_options():
	v_box_container_motion.hide()
	v_box_container_appearance.show()

func _on_menu_mouse_entered() -> void:
	ui_blocking = false


func _on_menu_mouse_exited() -> void:
	ui_blocking = true


#region slot options


func _on_slot_1_item_selected(index: int) -> void:
	option_selected("SLOT_1", index)


func _on_slot_2_item_selected(index: int) -> void:
	option_selected("SLOT_2", index)


func _on_slot_3_item_selected(index: int) -> void:
	option_selected("SLOT_3", index)


func _on_slot_4_item_selected(index: int) -> void:
	option_selected("SLOT_4", index)


func _on_slot_5_item_selected(index: int) -> void:
	option_selected("SLOT_5", index)


func _on_slot_6_item_selected(index: int) -> void:
	option_selected("SLOT_6", index)


func _on_slot_7_item_selected(index: int) -> void:
	option_selected("SLOT_7", index)


func _on_slot_8_item_selected(index: int) -> void:
	option_selected("SLOT_8", index)


func _on_slot_9_item_selected(index: int) -> void:
	option_selected("SLOT_9", index)


func _on_slot_10_item_selected(index: int) -> void:
	option_selected("SLOT_10", index)


func _on_slot_11_item_selected(index: int) -> void:
	option_selected("SLOT_11", index)


func _on_slot_12_item_selected(index: int) -> void:
	option_selected("SLOT_12", index)


func _on_slot_13_item_selected(index: int) -> void:
	option_selected("SLOT_13", index)


func _on_slot_14_item_selected(index: int) -> void:
	option_selected("SLOT_14", index)


func _on_slot_15_item_selected(index: int) -> void:
	option_selected("SLOT_15", index)


func _on_slot_16_item_selected(index: int) -> void:
	option_selected("SLOT_16", index)


func _on_slot_17_item_selected(index: int) -> void:
	option_selected("SLOT_17", index)


func _on_slot_18_item_selected(index: int) -> void:
	option_selected("SLOT_18", index)


func _on_slot_19_item_selected(index: int) -> void:
	option_selected("SLOT_19", index)


func _on_slot_20_item_selected(index: int) -> void:
	option_selected("SLOT_20", index)


func _on_slot_21_item_selected(index: int) -> void:
	option_selected("SLOT_21", index)


func _on_slot_22_item_selected(index: int) -> void:
	option_selected("SLOT_22", index)


func _on_slot_23_item_selected(index: int) -> void:
	option_selected("SLOT_23", index)


func _on_slot_24_item_selected(index: int) -> void:
	option_selected("SLOT_24", index)


func _on_slot_25_item_selected(index: int) -> void:
	option_selected("SLOT_25", index)


func _on_slot_26_item_selected(index: int) -> void:
	option_selected("SLOT_26", index)


func _on_slot_27_item_selected(index: int) -> void:
	option_selected("SLOT_27", index)


func _on_slot_28_item_selected(index: int) -> void:
	option_selected("SLOT_28", index)


func _on_slot_29_item_selected(index: int) -> void:
	option_selected("SLOT_29", index)


func _on_slot_30_item_selected(index: int) -> void:
	option_selected("SLOT_30", index)


func _on_slot_31_item_selected(index: int) -> void:
	option_selected("SLOT_31", index)


func _on_slot_32_item_selected(index: int) -> void:
	option_selected("SLOT_32", index)


func _on_slot_33_item_selected(index: int) -> void:
	option_selected("SLOT_33", index)


func _on_slot_34_item_selected(index: int) -> void:
	option_selected("SLOT_34", index)

func option_selected(slot:String, index:int):	
	var option_button:OptionButton = slot_options[slot]
	var item_text:String = option_button.get_item_text(index)
	var item_path:String = "%s/%s"%[TEST_OBJECTS_PATH, item_text]
	if item_text == "-":
		avatar.equip(slot, "")
		return
	avatar.equip(slot, item_path)
#endregion
