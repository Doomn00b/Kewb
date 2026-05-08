@icon("res://audio_system/audio_symbol.png")
class_name MusicAutoTrigger
extends Node

@export var music_track : AudioStream
@export var reverb : ReverbTypeE.E = ReverbTypeE.E.NONE

var am : AudioManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	am = AudioManager.instance
	am.play_music( music_track ) #This allows us to change track but keep the same or different reverb-effect.
	am.set_reverb( reverb )
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
