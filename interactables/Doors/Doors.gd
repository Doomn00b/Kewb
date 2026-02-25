@tool
@icon("res://interactables/Doors/door_symbol.png")
class_name Doors
extends Node2D

const DOOR_CRASH_AUDIO = preload("res://interactables/Doors/brick_break.ogg")

@onready var animation_player: AnimationPlayer = %AnimationPlayer #We get the doors animation-player the minute we start the game.

func _ready():
	if Engine.is_editor_hint():
		return
	#Add connection to button code.


func _on_button_activated() -> void:
	#Play sound-effect punch button.
	#Play sound-effect door opening.
	#Play button getting pressed animation.
	#Play door opening animation.
	animation_player.play("open") #Play the opening door animation.
	
func _on_button_remain() -> void: #When the button remains DOWN 
	animation_player.play("open") #We play the static opened animation.

#Anxiety-coding to check for missing button in the door-prefab:
func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_button() == false:
		return [ "Requires a Button as a child node."]
	return []

func _check_for_button() -> bool: #This function checks if the door has a button connected to it. (so it can be opened)
	for children in get_children():
		if children is Buttons: #Maybe add: or OTHER way of opening...?
			return true
	return false
