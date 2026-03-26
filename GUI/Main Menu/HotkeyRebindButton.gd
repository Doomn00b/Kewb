class_name HotKeyRebindButton
extends Control

@onready var action_label : Label = %ActionLabel
@onready var action_button : Button = %ActionButton

#This is meant to be based on the names of our actions set up in project settings, so controls.
@export var action_name: String = "move_left"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_input(false)
	set_action_name()
	
#TODO: Can I somehow use ENUMS in this function instead, where I map them together?
func set_action_name() -> void:
	action_label.text = "unassigned"
	
	match action_name: 
		"move_left":
			action_label.text = "Move Left"
		"move_right":
			action_label.text = "Move Right"
		"move_up":
			action_label.text = "Move Up"
		"move_up":
			action_label.text = "Move Up"
		"move_down":
			action_label.text = "Move Down"
		"jump":
			action_label.text = "Jump"
		"attack":
			action_label.text = "Attack"
