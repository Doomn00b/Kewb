extends Node
class_name FiniteStateMachine

@export var state: State #We make a new variable based on our state-script.

func _ready() -> void:
	change_state(state)
	
func change_state(new_state: State):
	if state is State: #This checks if our current state is actually a state, and not NULL.
		state._exit_state()
	new_state._enter_state()
	state = new_state #Since we checked that we had a new state, we make our current state the new state.
