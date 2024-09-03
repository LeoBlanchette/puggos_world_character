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

signal pre_slot_equiped(slot:Equippable, meta)
signal post_slot_equiped(slot:Equippable, meta)

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
signal slot_34_equipped(meta)
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
	SLOT_36,
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
	populate_slot_objects_dictionary()

func populate_slot_objects_dictionary():
	if not slot_objects.is_empty():
		return
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
		pre_slot_equiped.emit(equip_slot, meta)
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
			equip_anchorable_object(Equippable.SLOT_27, path, anchor_slot_27)
			slot_27_equipped.emit(meta)
		Equippable.SLOT_28:
			equip_anchorable_object(Equippable.SLOT_28, path, anchor_slot_28)
			slot_28_equipped.emit(meta)
		Equippable.SLOT_29:
			equip_anchorable_object(Equippable.SLOT_29, path, anchor_slot_29)
			slot_29_equipped.emit(meta)
		Equippable.SLOT_30:
			equip_anchorable_object(Equippable.SLOT_30, path, anchor_slot_30)
			slot_30_equipped.emit(meta)
		Equippable.SLOT_31:
			equip_anchorable_object(Equippable.SLOT_31, path, anchor_slot_31)
			slot_31_equipped.emit(meta)
		Equippable.SLOT_32:
			equip_anchorable_object(Equippable.SLOT_32, path, anchor_slot_32)
			slot_32_equipped.emit(meta)
		Equippable.SLOT_33:
			equip_anchorable_object(Equippable.SLOT_33, path, anchor_slot_33)
			slot_33_equipped.emit(meta)
		Equippable.SLOT_34:
			equip_anchorable_object(Equippable.SLOT_34, path, anchor_slot_34)
			slot_34_equipped.emit(meta)
		_:
			no_slot_equipped.emit(meta)
			
	if slot_found:
		post_slot_equiped.emit(equip_slot, meta)

## Equips a texture to the skin layers.
func equip_slot_texture(slot:Equippable, path:String):
	var original_material:StandardMaterial3D = character_mesh.get_surface_override_material(0)
	var new_material:StandardMaterial3D = get_material_template()
	
	new_material.albedo_texture = original_material.albedo_texture	
	new_material.next_pass.albedo_texture = original_material.next_pass.albedo_texture 
	new_material.next_pass.next_pass.albedo_texture = original_material.next_pass.next_pass.albedo_texture 
	
	var blank_texture_path:String = "res://addons/puggos_world_character/base_textures/_blank.png" 
	var default_texture_path:String = "res://addons/puggos_world_character/test_objects/slot_1/tan.png"
	match slot:
		Equippable.SLOT_1:
			if path.is_empty():
				path = default_texture_path
			new_material.albedo_texture = load(path) as CompressedTexture2D	
		Equippable.SLOT_2:
			if path.is_empty():
				path = blank_texture_path
			new_material.next_pass.albedo_texture = load(path) as CompressedTexture2D	
		Equippable.SLOT_3:
			if path.is_empty():
				path = blank_texture_path
			new_material.next_pass.next_pass.albedo_texture = load(path) as CompressedTexture2D	
	character_mesh.set_surface_override_material(0,new_material)

func get_material_template()->StandardMaterial3D:
	# Set up materials and nextpasses
	# SLOT 1
	var slot_1_material:StandardMaterial3D = StandardMaterial3D.new()
	slot_1_material.render_priority = 0
	
	# SLOT 2
	var slot_2_material:StandardMaterial3D = StandardMaterial3D.new()
	slot_2_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	slot_2_material.render_priority = 1
	
	#SLOT 3
	var slot_3_material:StandardMaterial3D = StandardMaterial3D.new()
	slot_3_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	slot_3_material.render_priority = 2
	
	# JOIN the material
	var material:StandardMaterial3D = slot_1_material
	material.next_pass = slot_2_material
	material.next_pass.next_pass =slot_3_material
	
	# Ship the product and hope it doesn't break.
	return material


## A general function to equip a rigged object. This object mouting is distinct 
## from something like a sword or ax because it is rigged to the body and the 
## after the mod is loaded, processed, and remapped to the body skeleton. 
func equip_rigged_object(slot:Equippable, path:String):
	populate_slot_objects_dictionary()
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


func equip_anchorable_object(slot:Equippable, path:String, anchor:Node3D):
	populate_slot_objects_dictionary()
	# Construct a string that will map to the slot_ variables above.
	var slot_var:String = Equippable.keys()[slot]
	# First, remove the old item before adding the new one.
	if slot_objects[slot_var] != null:
		slot_objects[slot_var].queue_free()
	slot_objects[slot_var]=null
	## Also remove existing item from anchor before adding new one or aborting.
	clear_anchor(anchor) 
	# If the path is empty, we've removed the item and we are done.
	if path.is_empty():		
		return
		
	# Get mod / resource and instantiate.
	var ob:Resource = load(path)
	var ob_instantiated:Node3D = ob.instantiate()
	
	if ob_instantiated == null:
		return
	
	anchor.add_child(ob_instantiated)
	
	#ob_instantiated.position = Vector3.ZERO
	#ob_instantiated.rotation_degrees = Vector3.ZERO
	print(ob_instantiated.get_parent())
	# Set the variable to future tracking and management.
	slot_objects[slot_var]=ob_instantiated

func clear_anchor(anchor:Node3D):
	for child in anchor.get_children():
		child.queue_free()
#region misc
static func get_slot_description(slot:Equippable)->String:
	var description:String = ""
	match slot:
		Equippable.SLOT_0:
			description = "Unassigned"
		Equippable.SLOT_1:
			description = "Skin base layer"
		Equippable.SLOT_2:
			description = "Skin Markings / Art / Tattoos"
		Equippable.SLOT_3:
			description = "Skin temporary effects"
		Equippable.SLOT_4:
			description = "Face"
		Equippable.SLOT_5:
			description = "Mask"
		Equippable.SLOT_6:
			description = "Hat / Helmet"
		Equippable.SLOT_7:
			description = "Hair / Decos"
		Equippable.SLOT_8:
			description = "Shirt"
		Equippable.SLOT_9:
			description = "Jacket"
		Equippable.SLOT_10:
			description = "Vest"
		Equippable.SLOT_11:
			description = "Backpack"
		Equippable.SLOT_12:
			description = "Accessories"
		Equippable.SLOT_13:
			description = "Arm Armor Left"
		Equippable.SLOT_14:
			description = "Arm Armor Right"
		Equippable.SLOT_15:
			description = "Glove Left"
		Equippable.SLOT_16:
			description = "Glove Right"
		Equippable.SLOT_17:
			description = "Arm Accessory Left"
		Equippable.SLOT_18:
			description = "Arm Accessory Right"
		Equippable.SLOT_19:
			description = "Belt"
		Equippable.SLOT_20:
			description = "Pants"
		Equippable.SLOT_21:
			description = "Leg Armor Left"
		Equippable.SLOT_22:
			description = "Leg Armor Right"
		Equippable.SLOT_23:
			description = "Footwear Left"
		Equippable.SLOT_24:
			description = "Footwear Right"
		Equippable.SLOT_25:
			description = "Leg Accessory Left"
		Equippable.SLOT_26:
			description = "Leg Accessory Right"
		Equippable.SLOT_27:
			description = "Back Left [Anchor_Slot_27]"
		Equippable.SLOT_28:
			description = "Back Right [Anchor_Slot_28]"
		Equippable.SLOT_29:
			description = "Hip Left [Anchor_Slot_29]"
		Equippable.SLOT_30:
			description = "Hip Left [Anchor_Slot_30]"
		Equippable.SLOT_31:
			description = "Chest Left [Anchor_Slot_31]"
		Equippable.SLOT_32:
			description = "Chest Right [Anchor_Slot_32]"
		Equippable.SLOT_33:
			description = "Hand Left [Anchor_Slot_33]"
		Equippable.SLOT_34:
			description = "Hand Right [Anchor_Slot_34]"
		Equippable.SLOT_35:
			description = "Other"
		Equippable.SLOT_36:
			description = "Other"
		Equippable.SLOT_37:
			description = "Other"
		Equippable.SLOT_38:
			description = "Other"
		Equippable.SLOT_39:
			description = "Other"
		_:
			description = "This is not a slot."
	return description
#endregion
