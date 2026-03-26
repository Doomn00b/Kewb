@tool
@icon("res://interactables/Doors/door_symbol.png")
class_name Doors
extends Node2D

const DOOR_CRASH_AUDIO = preload("res://interactables/Doors/brick_break.ogg")

@onready var animation_player: AnimationPlayer = %AnimationPlayer #We get the doors animation-player the minute we start the game.

func _ready():
	if Engine.is_editor_hint():
		return
	#This connects the door to the button.
	for children in get_children():
		if children is PunchButtons: #If there's a child that's a Button, then...
			children.button_activated.connect(_on_button_activated) #Connect the button_activated signal to the On-button-activated function.
			if children.is_open == true: #If our is-open bool in button has been set, then...
				_on_button_remain() #...make sure the door remains open.
			#break


func _on_button_activated() -> void:
	#Play sound-effect punch button.
	#Play sound-effect door opening. (through GLOBAL system)
	#Play button getting pressed animation.
	#Play door opening animation.
	animation_player.play("opening") #Play the opening door animation.
	
func _on_button_remain() -> void: #When the button remains DOWN 
	animation_player.play("open") #We play the static opened animation.

#Anxiety-coding to check for missing button in the door-prefab:
func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_button() == false:
		return [ "Requires a Button as a child node. (in a level)"] #In-editor warning text from the triangle.
	return []

func _check_for_button() -> bool: #This function checks if the door has a button connected to it. (so it can be opened)
	for children in get_children():
		if children is PunchButtons: #Maybe add: or OTHER way of opening...?
			return true
	return false
