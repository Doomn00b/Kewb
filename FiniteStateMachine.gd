extends Node
class_name FiniteStateMachine

@export var state: State #We make a new variable based on our state-script.
var state_dict : Dictionary[String, State] = {}

func _init() -> void:
	pass
	#UPDATE STATE DICT HERE
	
func _ready() -> void:
	state.enter_state()
	
func change_state(new_state : String):
	if !state_dict.has(new_state): #If our state-dictionary doesn't have a new state...
		push_error(new_state, " Does not exist in state dict") #...we get an error.
		return
	if state is State: #This checks if our current state is actually a state, and not NULL.
		state.exit_state() #We run the exit-state function.
	state = state_dict[new_state] #Since we exited the state, we check the dictionary for a new state.
	state.enter_state() #And then we enter the new state.

func _physics_process(delta: float) -> void:
	state.update_state(delta) #We continously update our current state.
