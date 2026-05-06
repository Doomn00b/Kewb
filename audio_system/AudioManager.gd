@icon("res://audio_system/audio_symbol.png")
class_name AudioManager
extends Node

@export_category("Put UI sounds here")
@export var ui_focus_audio : AudioStream
@export var ui_select_audio : AudioStream
@export var ui_cancel_audio : AudioStream
@export var ui_success_audio : AudioStream
@export var ui_error_audio : AudioStream

var current_track : int = 0
var music_tweens : Array [Tween]
var ui_audio_player : AudioStreamPlaybackPolyphonic

@onready var music_1: AudioStreamPlayer = %Music1
@onready var music_2: AudioStreamPlayer = %Music2
@onready var ui: AudioStreamPlayer = %UI

static var instance : AudioManager

func _init() -> void:
	instance = self

func _ready() -> void:
	ui.play()
	ui_audio_player = ui.get_stream_playback()
	print_debug("Got Ui Audio.")
	pass
	
func play_ui_audio( audio : AudioStream) -> void:
	#Guard-clause
	if ui_audio_player:
		ui_audio_player.play_stream( audio )
	else:
		return

#TODO: Consider using the MessageBus for this instead of grabbing and assigning the same to all of it.
func setup_button_audio( node : Node) -> void: #Grabs all UI-buttons and assigns appropriate sounds.
	for child in node.find_children("*", "Button"):
		child.pressed.connect(ui_select_aud) #Run the select-audio function for the children
		child.focus_entered.connect(ui_focus_change_aud) #Run focu
		pass
		
#region Functions for playing UI-sounds via other scripts.
func ui_focus_change_aud() -> void:
	play_ui_audio( ui_focus_audio )

func ui_select_aud() -> void:
	play_ui_audio( ui_select_audio )
	
func ui_cancel_aud() -> void:
	play_ui_audio( ui_cancel_audio )
	
func ui_success_aud() -> void:
	play_ui_audio( ui_success_audio )
	
func ui_error_aud() -> void:
	play_ui_audio( ui_error_audio )
#endregion
