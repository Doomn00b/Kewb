@icon("res://game_management/control_symbol.png")
class_name InputHints
extends Node2D

const HINT_MAP : Dictionary = {
	"keyboard" : {
		"interact" : 0,
		"jump" : 0,
		"attack" : 0,
		"charge" : 0
	}
}



@onready var sprite_2d: Sprite2D =%InputSprite
var controller_type: Array[ String ] = [
	"keyboard", "xbox", "playstation", "nintendo"]

func _ready() -> void:
	sprite_2d.visible = false #Hints should be invisible until they're needed.
	MessageBus.instance.input_hint_changed.connect(_on_hint_changed)

func _on_hint_changed( hint: GameEnums.HintMsg ) -> void:
	#If hint is nothing, as in when the player isn't standing by the button, then the message should dissappear.
	if hint == GameEnums.HintMsg.NOTHING:
		sprite_2d.visible = false
	else:
		sprite_2d.visible = true #Otherwise it's visible, since a new hint should be displayed.
