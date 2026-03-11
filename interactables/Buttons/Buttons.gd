@tool
@icon("res://interactables/Buttons/switch_symbol.png")
class_name Buttons
extends Node2D

signal button_activated

const DOOR_BUTTON_AUDIO = preload("res://interactables/Buttons/block_hit.ogg")
@onready var butt_sprite: Sprite2D = %VertButtSprite
@onready var butt_area = %ButtonArea2D
var is_open : bool = false

func _ready() -> void:
	#if SaveManager.persistent_data.get_or_add("door_01", "closed") == "open":
	if SaveManager : #ADD VARIABLE FROM SAVE-MANAGER, THAT CONCERNS DOORS/BUTTONS here.
		is_open = true
		# run set to open function
	else:
		#connect to signals
		butt_area.body_entered.connect(_on_player_entered)
		butt_area.body_exited.connect(_on_player_exited)
		
func _on_player_entered(_node: Node2D) -> void:
	MessageBus.instance.input_hint_changed.emit(GameEnums.HintMsg.INTERACT) #When the player enters, the hint-message INTERACT should be emitted.
	MessageBus.instance.player_interacted.connect(_on_player_interacted)
	
func  _on_player_exited(_node: Node2D) -> void:
	MessageBus.instance.input_hint_changed.emit(GameEnums.HintMsg.NOTHING) #When the player exits, the hint-message NOTHING makes the pop-up invisible.
	MessageBus.instance.player_interacted.disconnect(_on_player_interacted)

func _on_player_interacted(_player : Player) -> void:
	print_debug("Player Interacted.")
	#Add audio playback
	button_activated.emit() #If the player has interacted (PUNCHED) the button, then this signal emits.
	set_open()
	

func set_open() -> void:
	#
	pass

#If the door button has been punched, the door should stay open.
#But if the door hasn't been punched before, it should be closed.
#The tutorial talks to the save-manager to get a value from persistent data, 
#which says if the numbered door (door_01 for instance) is saved as open or close.
