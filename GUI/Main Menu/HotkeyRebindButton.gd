class_name HotKeyRebindButton
extends Control

@onready var action_label : Label = %ActionLabel
@onready var action_button : Button = %ActionButton

#This is meant to be based on the names of our actions set up in project settings, so controls.
@export var action_name: String = "move_left"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_input(false)
	set_action_name() #We get the strings for actions from the project settings and change their names.
	set_text_for_key() #We make the changed text for actions visible in our settings.
	
#TODO: Can I somehow use ENUMS in this function instead, where I map them together?
func set_action_name() -> void: #This function makes it so the rebindable action is displayed in a more readable way.
	action_label.text = "Unassigned"
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

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name) #We store all of the actions into action_events.
	var action_event = action_events[0] #we store a single action-event, by grabbing the first action-event in the action-events array.
	#HOW THE *FUCK* do I get Unicode instead of Physical, in the  below VAR?!
	var _action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	#print(action_keycode) #Turn this on later.
	
	#EXAMPLE FROM DOCS:
	#if event is InputEventKey:
		#var keycode = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		#var label = DisplayServer.keyboard_get_label_from_physical(event.physical_keycode)
		#print(OS.get_keycode_string(keycode))
		#print(OS.get_keycode_string(label))
