@icon("res://game_management/control_symbol.png")
class_name InputHints
extends Node2D

@onready var sprite_2d: Sprite2D =%InputSprite

const HINT_MAP: Dictionary = {
	ConTypeEnum.E.KEYBOARD : {
	InputNameEnum.E.INTERACT : &"interact", #frame 3 pc, 
	InputNameEnum.E.JUMP : &"jump", #frame 0 pc, 8 ps, 16 ninty, 24 xb
	InputNameEnum.E.ATTACK : &"attack", #frame 1
	InputNameEnum.E.CHARGE : &"charge", #frame 2
	InputNameEnum.E.MOVE_UP : &"move_up", #frame 4
	InputNameEnum.E.MOVE_DOWN : &"move_down", #frame 5
	InputNameEnum.E.MOVE_LEFT : &"move_left", #frame 6
	InputNameEnum.E.MOVE_RIGHT : &"move_right", #frame 7
	},
	ConTypeEnum.E.PLAYSTATION: {
	
	}
}

var controller_type: ConTypeEnum.E = ConTypeEnum.E.KEYBOARD #We store our different controller-types in a variable.
#Sadly the above variable is preset to keyboard, but hopefully we can fix in the future...

func _ready() -> void:
	sprite_2d.visible = false #Hints should be invisible until they're needed.
	MessageBus.instance.input_hint_changed.connect(_on_hint_changed)

func _on_hint_changed( hint: HintMsgEnum.E ) -> void:
	#If hint is nothing, as in when the player isn't standing by the button, then the message should dissappear.
	if hint == HintMsgEnum.E.NO_HINT:
		sprite_2d.visible = false
	else:
		sprite_2d.visible = true #Otherwise it's visible, since a new hint should be displayed.
		#UPDATE HINT-SPRITE HERE
