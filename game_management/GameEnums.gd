class_name GameEnums
extends Node

static var instance : GameEnums

func _init() -> void:
	instance = self

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
	INTERACT,
	NOTHING
}
