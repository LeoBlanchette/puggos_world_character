extends AnimationTree

class_name CharacterAnimationTree

enum {
	NONE,
	CROUCHED,
	COMBAT_MODE,
	COMBAT_MODE_MOVING,
}



var state = NONE

func set_to_none():
	state = NONE

func set_to_crouched():
	state = CROUCHED

func set_to_combat_mode():
	state = COMBAT_MODE
	
func set_to_moving_combat_mode():
	state = COMBAT_MODE_MOVING
