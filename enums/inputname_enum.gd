class_name InputNameEnum

enum E {
	INTERACT,
	JUMP,
	ATTACK,
	CHARGE,
	MOVE_UP,
	MOVE_DOWN,
	MOVE_LEFT,
	MOVE_RIGHT,
	PAUSE
}

#var InputLookup: Dictionary = {
	#E.INTERACT : &"interact",
	#E.JUMP : &"jump",
	#E.ATTACK : &"attack",
	#E.CHARGE : &"charge",
	#E.MOVE_UP : &"move_up",
	#E.MOVE_DOWN : &"move_down",
	#E.MOVE_LEFT : &"move_left",
	#E.MOVE_RIGHT : &"move_right",
#}
