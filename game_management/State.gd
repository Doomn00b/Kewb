#This script is a template for how to have a state (in a state-machine), and
#will be inherited by other scripts.
@abstract 
class_name State
extends Node
signal state_finished #We give the script the ability to send a signal, that it's done.

@abstract 
func enter_state() -> void

@abstract
func update_state(delta : float) -> void

@abstract 
func exit_state() -> void
	
