class_name BeAggroState
extends State

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.


# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	var sm : FiniteStateMachine = get_parent()
	#b_found_player.connect(sm.change_state.bind("Aggroed")) #We connect the found player signal to activate the rush state
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

 
func enter_state() -> void:
	print_debug("Boss entered AGGRO!")

func update_state(_delta : float) -> void:
	pass

func _aggroing():
	if actor.spot_p_shapecast.is_colliding():
		actor.animator.play("b_attack")


func exit_state() -> void:
	print_debug("Boss exited Aggro")
