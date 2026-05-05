class_name PlayWalkState
extends State

@export_category("Put Actor, aka Player-prefab here")
@export var actor: NewPlayer #We put our "Actor" here, in this case, our Player-kewb.

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	var sm : FiniteStateMachine = get_parent()
	#b_found_player.connect(sm.change_state.bind("Aggroed")) #We connect the found player signal to activate the rush state
	
func enter_state() -> void:
	print_debug("Player entered Walking.")
func update_state(delta : float) -> void:
	_walking()

func _walking():
	actor.animator.play("player_walk") #We play the walking-animation, using the Actors animator.

func exit_state() -> void:
	print_debug("Player exit Idling")
