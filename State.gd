#This script is a template for how to have a state (in a state-machine), and
#will be inherited by other scripts.
class_name State
extends Node
signal state_finished #We give the script the ability to send a signal, that it's done.

func _enter_state() -> void:
	pass

func _exit_state() -> void:
	pass
