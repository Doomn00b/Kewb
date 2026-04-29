class_name BeLaughState
extends State

signal b_found_p_while_laugh

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sm : FiniteStateMachine = get_parent()
	#var callable : Callable = Callable(sm, "change_state").bind("Aggroed")
	b_found_p_while_laugh.connect(sm.change_state.bind("Aggroed")) 
	#b_found_p_while_laugh.connect(sm.change_state("Aggroed")) 

func enter_state() -> void:
	actor.animator.play("b_laugh")
	print_debug("The Boss Laughed at the Player...")

func update_state(_delta : float) -> void:
	#region guard-clause for update
	if actor.animator.is_playing(): #If we're still playing the animation from enter-state, then...
		return #...just restart this function.
	#endregion
	if actor.spot_p_shapecast.is_colliding(): #If the player is in line of sight of the boss...
		b_found_p_while_laugh.emit() #Say we found the player.
	
func exit_state() -> void:
	print_debug("The Boss stopped laughing.")
