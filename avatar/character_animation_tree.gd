extends AnimationTree

class_name CharacterAnimationTree

enum {
	NONE,
	CROUCHED,
}

var state = NONE

func set_to_none():
	state = NONE

func set_to_crouched():
	state = CROUCHED
