@tool
@icon("res://interactables/Buttons/switch_symbol.png")
class_name PunchButtons
extends Node2D

signal button_activated

const DOOR_BUTTON_AUDIO = preload("res://interactables/Buttons/block_hit.ogg")
@onready var butt_anim: AnimationPlayer = %BAnimPlayer
@onready var butt_area: Area2D = %ButtonArea2D
var is_open : bool = false

func _ready() -> void:
	#Original code: 
	#if SaveManager.persistent_data.get_or_add(unique_name(), "closed") == "open"
	#original uses dictionaries function to get the name of the door and if it's closed or not...
	if SaveManager.instance.save_game != null : #If there's a save,then...
		is_open = true
		set_open() # run set to open function, if there's save-data.
	
	#connect to signals
	butt_area.body_entered.connect(_on_player_entered) #Used for tool-tip
	butt_area.body_exited.connect(_on_player_exited) #Used for turning off tool-tip.
	butt_area.area_entered.connect(_on_player_punched)
		
		
func _on_player_entered(_node: Node2D) -> void: #When the player walks next to the buttons collider.
	MessageBus.instance.input_hint_changed.emit(HintMsgEnum.E.INTERACTMSG) #When the player enters, the hint-message INTERACT should be emitted.
	print_debug("Player entered button-range.")
	
func _on_player_exited(_node: Node2D) -> void: #Maybe ON-FIST-EXITED?
	MessageBus.instance.input_hint_changed.emit(HintMsgEnum.E.NO_HINT) #When the player exits, the hint-message NO_HINT makes the pop-up invisible.
	print_debug("Player EXITED Button-range.")

func _on_player_punched(area: Area2D) -> void: #This is what happens if you punch the button.
	if area == get_tree().get_first_node_in_group("playerDmgGroup"): #If the area that enters is the FIST
		print_debug("Player punched button.")
		MessageBus.instance.player_interacted.emit() #After punching we send a signal that we have interacted.
		_on_player_interacted()

func _on_player_interacted() -> void:
	print_debug("Player Interacted.")
	#if SaveManager.instance.save_game != null : #Check our persistent data if the player has already interacted/opened the door.
	#Add audio playback
	button_activated.emit() #If the player has interacted (PUNCHED) the button, then this signal emits.
	butt_anim.play("pressing") #We play the pressing-animation.
	set_open()
	
func set_open() -> void:
	is_open = true
	#MessageBus.instance.player_interacted.disconnect(_on_player_interacted)
	butt_anim.play("pressed")
	butt_area.queue_free() #We destroy the collider, so we can't punch the button again.
#This might be necessary to change, if I want doors that can be reopened...

func unique_name() -> String:
	#We make a unique name for this button, based on the ResourceUnique-ID, which we get from
	#the scene's (which the button is in) file path.
	var u_name : String = ResourceUID.path_to_uid(owner.scene_file_path)
	u_name += "/" + get_parent().name + "/" + name #Then we append to our u-name, more, from the other nested scenes its in.
	#Remember to name every door uniquely in the tree!! Or the above won't work.
	return u_name
	
#If the door button has been punched, the door should stay open.
#But if the door hasn't been punched before, it should be closed.
#The tutorial talks to the save-manager to get a value from persistent data, 
#which says if the numbered door (door_01 for instance) is saved as open or close.
