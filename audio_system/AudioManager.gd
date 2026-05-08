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

var ab : AudioBus

static var instance : AudioManager

func _init() -> void:
	instance = self

func _ready() -> void:
	ab = AudioBus.instance
	#region Connect the audio-bus signals to run the functions for UI-sounds.
	ab.run_ui_focus_change_aud.connect(ui_focus_change_aud) 
	ab.run_ui_select_aud.connect(ui_select_aud)
	ab.run_ui_canc_aud.connect(ui_cancel_aud)
	ab.run_ui_success_aud.connect(ui_success_aud)
	ab.run_ui_error_aud.connect(ui_error_aud)
	#endregion
	
	#region To play UI-audio
	ui.play()
	ui_audio_player = ui.get_stream_playback()
	print_debug("Got Ui Audio.")
	#endregion
	
func play_music( audio : AudioStream) -> void:
	#Get or determine current music playing.
	var current_player : AudioStreamPlayer = get_music_player( current_track )
	if current_player.stream == audio: #If we're already playing an Audiostream, then...
		return #...don't do anything.
	#Determine which the next music-track is.
	var next_track : int = wrapi( current_track + 1, 0, 2 ) #Variable to determine the next track to play.
	var next_audplayer : AudioStreamPlayer = get_music_player( next_track )
	#Set the audio on the next music-player.
	next_audplayer.stream = audio
	next_audplayer.play()
	#Handle audio-fades.
	
	#Store/Set current music track
	current_track = next_track
	
func get_music_player( i : int) -> AudioStreamPlayer: #TODO: this function should probably use a dictionary and a switch...
	if i == 0 :#If i is 0, then it's the first music-player, so...
		return music_1
	else:
		return music_2
	
	
func set_reverb( type : ReverbTypeE.E ): #Sets the type of reverb to the sound being played.
	pass
	
func play_ui_audio( audio : AudioStream) -> void:
	#Guard-clause
	if ui_audio_player:
		ui_audio_player.play_stream( audio )
	else:
		return

#This function is run from other scripts to assign sounds to button-objects.
func setup_button_audio( node : Node) -> void: #Grabs all UI-buttons and assigns appropriate sounds.
	for child in node.find_children("*", "Button"):
		child.pressed.connect(ui_select_aud) #Run the select-audio function for the children
		child.focus_entered.connect(ui_focus_change_aud) #Run focu
		
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
