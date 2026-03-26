#TODO: Should this be a GlobalInput autoload singleton instead?
		#IS IT already that, because of our Singleton-system with MAIN?
class_name GameEnums
extends Node

static var instance : GameEnums

func _init() -> void:
	instance = self

#The below ENUMS are for distinguishing between pop-up Tool-top hints for buttons.
enum HintMsg { #Rename to HintButtons?
	#The below are ENUMS for input-hints, from various controllers.
	PSSQUARE,
	PSCIRCLE,
	PSTRIANGLE,
	PSCROSS,
	PSOPTION,
	XBA,
	XBB,
	XBX,
	XBY,
	KBSPACE,
	KBZ,
	KBX,
	NO_HINT,
	INTERACTMSG
}
#These enums are meant to help make a dictionary to map button-types to certain controllers.
enum ControllerType {
	KEYBOARD,
	XBOX,
	PLAYSTATION,
	NINTENDO
}

enum InputName {
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

var InputLookup: Dictionary = {
	InputName.INTERACT : &"ui_accept",
	InputName.JUMP : &"jump",
	InputName.ATTACK : &"attack",
	InputName.CHARGE : &"charge",
	InputName.MOVE_UP : &"move_up",
	InputName.MOVE_DOWN : &"move_down",
	InputName.MOVE_LEFT : &"move_left",
	InputName.MOVE_RIGHT : &"move_right",
	
}
