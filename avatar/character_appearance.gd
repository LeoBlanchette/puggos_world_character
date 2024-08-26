extends Node3D

## Main class for avatar appearance customization. Ample signals 
## have been provided for modders to utilize. Class deals directly 
## with Slot Numbers and Resource Paths provided by higher level controllers.
## Also, we deal directly with resource paths to load items so that 
## experimentation and development can happen on SDK / Modder side before
## uploading to actual game.
## Remember that the Avatar / Character appearance is cosmetic only.
## Stat and physical effects of loaded gear are applied at Character Controller 
## level.
class_name  CharacterAppearance

signal pre_slot_equiped(slot:Equippable)
signal post_slot_equiped(slot:Equippable)

signal slot_0_equipped(meta)
signal slot_1_equipped(meta)
signal slot_2_equipped(meta)
signal slot_3_equipped(meta)
signal slot_4_equipped(meta)
signal slot_5_equipped(meta)
signal slot_6_equipped(meta)
signal slot_7_equipped(meta)
signal slot_8_equipped(meta)
signal slot_9_equipped(meta)
signal slot_10_equipped(meta)
signal slot_11_equipped(meta)
signal slot_12_equipped(meta)
signal slot_13_equipped(meta)
signal slot_14_equipped(meta)
signal slot_15_equipped(meta)
signal slot_16_equipped(meta)
signal slot_17_equipped(meta)
signal slot_18_equipped(meta)
signal slot_19_equipped(meta)
signal slot_20_equipped(meta)
signal slot_21_equipped(meta)
signal slot_22_equipped(meta)
signal slot_23_equipped(meta)
signal slot_24_equipped(meta)
signal slot_25_equipped(meta)
signal slot_26_equipped(meta)
signal slot_27_equipped(meta)
signal slot_28_equipped(meta)
signal slot_29_equipped(meta)
signal slot_30_equipped(meta)
signal slot_31_equipped(meta)
signal slot_32_equipped(meta)
signal slot_33_equipped(meta)
signal no_slot_equipped(meta)

enum Equippable{
	#HAIR 
	SLOT_0,
	
	#SKIN
	SLOT_1,  #Skin base layer
	SLOT_2,  #Skin Markings
	SLOT_3,  #Skin Environmental
	
	#HEAD
	SLOT_4,  #Face
	SLOT_5,  #Mask
	SLOT_6,  #Hat / Helmet
	SLOT_7,  #Hair / Decos
	
	#TORSO
	SLOT_8,  #Shirt (or torso layer 1) (in 3d, .01 offset)
	SLOT_9,  #Jacket (or torso layer 2) (in 3d, .02 offset, or .05 if exclude vest.)
	SLOT_10, #Vest (or torso layer 3) (in 3d, .05 offset)
	SLOT_11, #Backpack
	SLOT_12, #Accessories
	
	#ARMS
	SLOT_13, #Arm Armor Left
	SLOT_14, #Arm Armor Right
	SLOT_15, #Glove Left
	SLOT_16, #Glove Right
	SLOT_17, #Arm Accessory Left
	SLOT_18, #Arm Accessory Right
	
	#LEGS,
	SLOT_19, #Belt
	SLOT_20, #Pants
	SLOT_21, #Leg Armor Left
	SLOT_22, #Leg Armor Right
	SLOT_23, #Footwear Left
	SLOT_24, #Footwear Right
	SLOT_25, #Leg Accessory Left
	SLOT_26, #Leg Accessory Right
	
	#ANCHOR POINTS
	SLOT_27, #Back Left
	SLOT_28, #Back Right
	SLOT_29, #Hip Left
	SLOT_30, #Hip Right
	SLOT_31, #Chest Left
	SLOT_32, #Chest Right
	SLOT_33, #Hand Left
	SLOT_34, #Hand Right
	
	#OTHER
	SLOT_35,
	SLOT_37,
	SLOT_38,
	SLOT_39,
}

#region slot variables
var slot_objects:Dictionary = {}
#endregion

@export var character_mesh: MeshInstance3D 
@export var skeleton_3d: Skeleton3D 

@export var anchor_slot_27: Node3D #Back Left 
@export var anchor_slot_28: Node3D #Back Right
@export var anchor_slot_29: Node3D #Hip Left
@export var anchor_slot_30: Node3D #Hip Right
@export var anchor_slot_31: Node3D #Chest Left
@export var anchor_slot_32: Node3D #Chest Right
@export var anchor_slot_33: Node3D #Hand Left
@export var anchor_slot_34: Node3D #Hand Right


func _ready() -> void:
	for x:int in range(Equippable.keys().size()):
		slot_objects["SLOT_%s"%str(x)] = null


## Main entry point for equiping visible items. 
## Provide Slot number and Path to resource. Meta is optional arbitrary information you
## may include for use in the signals above, such as providing / getting information
## concerning an eqiupped item.
## Path (res://...) is obtained from character controller via ID and provided to character
## avatar. Character avatar relays request to this function.
func equip_slot(slot:String, path:String, meta=null):	
	slot = slot.to_upper()
	var equip_slot:Equippable
	var slot_found:bool = false
	if Equippable.has(slot):
		slot_found = true
		equip_slot = Equippable.get(slot)
		pre_slot_equiped.emit(equip_slot)
	match equip_slot:
		Equippable.SLOT_0:
			equip_rigged_object(Equippable.SLOT_0, path)
			slot_0_equipped.emit(meta)
		Equippable.SLOT_1:
			equip_slot_texture(Equippable.SLOT_1, path)
			slot_1_equipped.emit(meta)
		Equippable.SLOT_2:
			equip_slot_texture(Equippable.SLOT_2, path)
			slot_2_equipped.emit(meta)
		Equippable.SLOT_3:
			equip_slot_texture(Equippable.SLOT_3, path)
			slot_3_equipped.emit(meta)
		Equippable.SLOT_4:
			equip_rigged_object(Equippable.SLOT_4, path)
			slot_4_equipped.emit(meta)
		Equippable.SLOT_5:
			equip_rigged_object(Equippable.SLOT_5, path)
			slot_5_equipped.emit(meta)
		Equippable.SLOT_6:
			equip_rigged_object(Equippable.SLOT_6, path)
			slot_6_equipped.emit(meta)
		Equippable.SLOT_7:
			equip_rigged_object(Equippable.SLOT_7, path)
			slot_7_equipped.emit(meta)
		Equippable.SLOT_8:
			equip_rigged_object(Equippable.SLOT_8, path)
			slot_8_equipped.emit(meta)
		Equippable.SLOT_9:
			equip_rigged_object(Equippable.SLOT_9, path)
			slot_9_equipped.emit(meta)
		Equippable.SLOT_10:
			equip_rigged_object(Equippable.SLOT_10, path)
			slot_10_equipped.emit(meta)
		Equippable.SLOT_11:
			equip_rigged_object(Equippable.SLOT_11, path)
			slot_11_equipped.emit(meta)
		Equippable.SLOT_12:
			equip_rigged_object(Equippable.SLOT_12, path)
			slot_12_equipped.emit(meta)
		Equippable.SLOT_13:
			equip_rigged_object(Equippable.SLOT_13, path)
			slot_13_equipped.emit(meta)
		Equippable.SLOT_14:
			equip_rigged_object(Equippable.SLOT_14, path)
			slot_14_equipped.emit(meta)
		Equippable.SLOT_15:
			equip_rigged_object(Equippable.SLOT_15, path)
			slot_15_equipped.emit(meta)
		Equippable.SLOT_16:
			equip_rigged_object(Equippable.SLOT_16, path)
			slot_16_equipped.emit(meta)
		Equippable.SLOT_17:
			equip_rigged_object(Equippable.SLOT_17, path)
			slot_17_equipped.emit(meta)
		Equippable.SLOT_18:
			equip_rigged_object(Equippable.SLOT_18, path)
			slot_18_equipped.emit(meta)
		Equippable.SLOT_19:
			equip_rigged_object(Equippable.SLOT_19, path)
			slot_19_equipped.emit(meta)
		Equippable.SLOT_20:
			equip_rigged_object(Equippable.SLOT_20, path)
			slot_20_equipped.emit(meta)
		Equippable.SLOT_21:
			equip_rigged_object(Equippable.SLOT_21, path)
			slot_21_equipped.emit(meta)
		Equippable.SLOT_22:
			equip_rigged_object(Equippable.SLOT_22, path)
			slot_22_equipped.emit(meta)
		Equippable.SLOT_23:
			equip_rigged_object(Equippable.SLOT_23, path)
			slot_23_equipped.emit(meta)
		Equippable.SLOT_24:
			equip_rigged_object(Equippable.SLOT_24, path)
			slot_24_equipped.emit(meta)
		Equippable.SLOT_25:
			equip_rigged_object(Equippable.SLOT_25, path)
			slot_25_equipped.emit(meta)
		Equippable.SLOT_26:
			equip_rigged_object(Equippable.SLOT_26, path)
			slot_26_equipped.emit(meta)
		Equippable.SLOT_27:
			slot_27_equipped.emit(meta)
		Equippable.SLOT_28:
			slot_28_equipped.emit(meta)
		Equippable.SLOT_29:
			slot_29_equipped.emit(meta)
		Equippable.SLOT_30:
			slot_30_equipped.emit(meta)
		Equippable.SLOT_31:
			slot_31_equipped.emit(meta)
		Equippable.SLOT_32:
			slot_32_equipped.emit(meta)
		Equippable.SLOT_33:
			slot_33_equipped.emit(meta)
		_:
			no_slot_equipped.emit(meta)
			
	if slot_found:
		post_slot_equiped.emit(equip_slot)

## Equips a texture to the skin layers.
func equip_slot_texture(slot:Equippable, path:String):
	var material:StandardMaterial3D
	var blank_texture_path:String = "res://addons/puggos_world_character/base_textures/_blank.png" 
	var default_texture_path:String = "res://addons/puggos_world_character/test_objects/slot_1/tan.png"
	match slot:
		Equippable.SLOT_1:
			material = character_mesh.get_surface_override_material(0)
			if path.is_empty():
				path = default_texture_path
		Equippable.SLOT_2:
			material = character_mesh.get_surface_override_material(0).next_pass
			if path.is_empty():
				path = blank_texture_path
		Equippable.SLOT_3:
			material = character_mesh.get_surface_override_material(0).next_pass.next_pass
			if path.is_empty():
				path = blank_texture_path
				
	var texture:Texture2D = load(path)
	material.albedo_texture = texture

## A general function to equip a rigged object. This object mouting is distinct 
## from something like a sword or ax because it is rigged to the body and the 
## after the mod is loaded, processed, and remapped to the body skeleton. 
func equip_rigged_object(slot:Equippable, path:String):
	# Construct a string that will map to the slot_ variables above.
	var slot_var:String = Equippable.keys()[slot]
	# First, remove the old item before adding the new one.
	if slot_objects[slot_var] != null:
		slot_objects[slot_var].queue_free()
	slot_objects[slot_var]=null
	# If the path is empty, we've removed the item and we are done.
	if path.is_empty():		
		return
		
	# Get mod / resource and instantiate.
	var ob:Resource = load(path)
	var ob_instantiated:Node3D = ob.instantiate()
	# Add the object to the skeleton and ensure it's position / rotation.
	skeleton_3d.add_child(ob_instantiated)
	ob_instantiated.position = Vector3.ZERO
	ob_instantiated.rotation = Vector3.ZERO
	
	# Get the relevant mesh that must be a child of the imported object. 
	# The path of the imported mesh must match Armature/Skeleton3D. 
	var skel:Skeleton3D = ob_instantiated.get_node("Armature/Skeleton3D")
	
	if skel == null:
		print("Object does not have a skeleton. Cannot be fit to rig.")
		return
	
	# Get only the first child. Multiple meshes are not allowed.
	
	var child = skel.get_child(0)
	if not child is MeshInstance3D:
		return
	var mesh:MeshInstance3D = child
	
	# Reparent the mesh to the character skeleton.
	mesh.reparent(skeleton_3d)
	
	# Map the skeleton to the character skeleton.
	mesh.skeleton = skeleton_3d.get_path()
	
	# Set the variable to future tracking and management.
	slot_objects[slot_var]=mesh
	
	# Cleanup. Remove the original instantiated object.
	ob_instantiated.queue_free()
