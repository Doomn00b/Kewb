#TODO: Should this be a GlobalInput autoload singleton instead?
		#IS IT already that, because of our Singleton-system with MAIN?
class_name GameEnums
extends Node

static var instance : GameEnums

func _init() -> void:
	instance = self


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
