@icon("res://audio_system/audio_symbol.png")
class_name MusicAutoTrigger
extends Node

@export var music_track : AudioStream
@export var reverb : ReverbTypeE.E = ReverbTypeE.E.NONE

@export_category("Choose which music to play in the scene, by inputing the dictionary # here:")
@export var _music_id : int = 0

var am : AudioManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#TODO: add a frame of latency here? To make sure AudioManager is loaded first
	am = AudioManager.instance #We grab the current AudioManager instance, so we're up to date.
	#am.play_music( music_track ) #This allows us to change track but keep the same or different reverb-effect.
	am.play_music_id(_music_id)
	am.set_reverb( reverb )
	print_debug("Played Auto-trig-music:", music_track )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
