@icon("res://audio_system/audio_symbol.png")
class_name MusicAutoTrigger
extends Node

@export var music_track : AudioStream
@export var reverb : ReverbTypeE.E = ReverbTypeE.E.NONE

@export_category("Choose which music to play in the scene, by inputing the dictionary # here:")
@export var _music_id : int #= 0 #Music-id is an INT, so it's the same type as the entries in the audio-manager Dictionary.

@export_category("Press this to make the autoplay even if it's not the current level.")
@export var play_anyway : bool = false

@onready var gm: GameManager #= GameManager.instance
@onready var am : AudioManager #= AudioManager.instance

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#am.play_music( music_track ) #This allows us to change track but keep the same or different reverb-effect.
	#am.set_reverb( reverb )
	#print_debug("Played Auto-trig-music:", music_track )
	gm = GameManager.instance
	am = AudioManager.instance
	
	await gm.ready #Wait for the game-manager to get ready.
	
	parent = self.get_parent()
	print_debug("This is a MusicAutoTrigger's parent:" , parent)
	
	if parent.visible == false:
		print_debug("This level or GUI:" , parent , "shall not play this music:" , _music_id , "because it's not the current level.")
		return
	
	elif parent.visible or play_anyway == true:
		am.play_music_id(_music_id) #Give our assigned music-id INT to the AudioManager.
		am.set_reverb( reverb )
		print_debug("Played Auto-trig-music:", _music_id )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
