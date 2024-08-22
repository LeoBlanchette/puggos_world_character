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

signal slot_1_equipped
signal slot_2_equipped
signal slot_3_equipped
signal slot_4_equipped
signal slot_5_equipped
signal slot_6_equipped
signal slot_7_equipped
signal slot_8_equipped
signal slot_9_equipped
signal slot_10_equipped
signal slot_11_equipped
signal slot_12_equipped
signal slot_13_equipped
signal slot_14_equipped
signal slot_15_equipped
signal slot_16_equipped
signal slot_17_equipped
signal slot_18_equipped
signal slot_19_equipped
signal slot_20_equipped
signal slot_21_equipped
signal slot_22_equipped
signal slot_23_equipped
signal slot_24_equipped
signal slot_25_equipped
signal slot_26_equipped
signal slot_27_equipped
signal slot_28_equipped
signal slot_29_equipped
signal slot_30_equipped
signal slot_31_equipped
signal slot_32_equipped
signal slot_33_equipped
signal slot_34_equipped
signal no_slot_equipped

enum Equippable{
	#SKIN
	SLOT_1,  #Skin base layer
	SLOT_2,  #Skin Markings
	SLOT_3,  #Skin Environmental
	
	#HEAD
	SLOT_4,  #Face
	SLOT_5,  #Mask
	SLOT_6,  #Hat / Helmet
	SLOT_7,  #Head Accessories / Misc
	
	#TORSO
	SLOT_8,  #Shirt (or torso layer 1)
	SLOT_9,  #Jacket (or torso layer 2)
	SLOT_10, #Vest (or torso layer 3)
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
}

@export var character_mesh: MeshInstance3D 

## Main entry point for equiping visible items. 
## Provide Slot number and Path to resource.
## Path is obtained from character controller via ID and provided to character
## avatar. Character avatar relays request to this function.
func equip_slot(slot:String, path:String):	
	slot = slot.to_upper()
	var equip_slot:Equippable
	var slot_found:bool = false
	if Equippable.has(slot):
		slot_found = true
		equip_slot = Equippable.get(slot)
		pre_slot_equiped.emit(equip_slot)
	match equip_slot:
		Equippable.SLOT_1:
			equip_slot_texture(Equippable.SLOT_1, path)
			slot_1_equipped.emit()
		Equippable.SLOT_2:
			equip_slot_texture(Equippable.SLOT_2, path)
			slot_2_equipped.emit()
		Equippable.SLOT_3:
			equip_slot_texture(Equippable.SLOT_3, path)
			slot_3_equipped.emit()
		Equippable.SLOT_4:
			slot_4_equipped.emit()
		Equippable.SLOT_5:
			slot_5_equipped.emit()
		Equippable.SLOT_6:
			slot_6_equipped.emit()
		Equippable.SLOT_7:
			slot_7_equipped.emit()
		Equippable.SLOT_8:
			slot_8_equipped.emit()
		Equippable.SLOT_9:
			slot_9_equipped.emit()
		Equippable.SLOT_10:
			slot_10_equipped.emit()
		Equippable.SLOT_11:
			slot_11_equipped.emit()
		Equippable.SLOT_12:
			slot_12_equipped.emit()
		Equippable.SLOT_13:
			slot_13_equipped.emit()
		Equippable.SLOT_14:
			slot_14_equipped.emit()
		Equippable.SLOT_15:
			slot_15_equipped.emit()
		Equippable.SLOT_16:
			slot_16_equipped.emit()
		Equippable.SLOT_17:
			slot_17_equipped.emit()
		Equippable.SLOT_18:
			slot_18_equipped.emit()
		Equippable.SLOT_19:
			slot_19_equipped.emit()
		Equippable.SLOT_20:
			slot_20_equipped.emit()
		Equippable.SLOT_21:
			slot_21_equipped.emit()
		Equippable.SLOT_22:
			slot_22_equipped.emit()
		Equippable.SLOT_23:
			slot_23_equipped.emit()
		Equippable.SLOT_24:
			slot_24_equipped.emit()
		Equippable.SLOT_25:
			slot_25_equipped.emit()
		Equippable.SLOT_26:
			slot_26_equipped.emit()
		Equippable.SLOT_27:
			slot_27_equipped.emit()
		Equippable.SLOT_28:
			slot_28_equipped.emit()
		Equippable.SLOT_29:
			slot_29_equipped.emit()
		Equippable.SLOT_30:
			slot_30_equipped.emit()
		Equippable.SLOT_31:
			slot_31_equipped.emit()
		Equippable.SLOT_32:
			slot_32_equipped.emit()
		Equippable.SLOT_33:
			slot_33_equipped.emit()
		Equippable.SLOT_34:
			slot_34_equipped.emit()
		_:
			no_slot_equipped.emit()
			
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
