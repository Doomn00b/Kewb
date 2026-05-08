#This will create a node that can broadcast a signal that an interaction has occurred, 
#and ANY other node can listen in, without a need to look for an instance of the player.
#This entire class is a container for AUDIO-signals.
@icon("res://audio_system/audio_symbol.png")
class_name AudioBus
extends Node

@warning_ignore("unused_signal")
signal run_ui_focus_change_aud

@warning_ignore("unused_signal")
signal run_ui_select_aud

@warning_ignore("unused_signal")
signal run_ui_canc_aud #Tells that the health has changed.

@warning_ignore("unused_signal")
signal run_ui_success_aud

@warning_ignore("unused_signal")
signal run_ui_error_aud

static var instance

func _init() -> void:
	instance = self
