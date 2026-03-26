class_name BeIdlingState
extends State

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.

signal b_found_player #Signal that sends to charging-state.

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	var sm : FiniteStateMachine = get_parent()
	b_found_player.connect(sm.change_state.bind("Aggroed")) #We connect the found player signal to activate the rush state
	
func enter_state() -> void:
	print_debug("Boss entered Idling.")

func update_state(_delta : float) -> void:
	_idling()

func _idling():
	actor.animator.play("b_idling") #We play the walking-animation, using the Actors animator.
	
func _seek_player(_delta):
	if actor.spot_p_shapecast.is_colliding(): #If our attack-raycast is colliding, then...
		b_found_player.emit() #...emit the signal that we've found the player.
		print_debug("Boss saw player.")

func exit_state() -> void:
	print_debug("Boss exit Idling")
