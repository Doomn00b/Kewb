class_name BeBackState
extends State

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sm : FiniteStateMachine = get_parent()
 
func enter_state() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_state(_delta : float) -> void:
	pass

func exit_state() -> void:
	print_debug("Boss stopped backing off.")
