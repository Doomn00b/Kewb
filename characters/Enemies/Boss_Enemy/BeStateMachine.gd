class_name BeStateMachine
extends FiniteStateMachine

@export var actor: BossEnemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_dict["Idling"] = %BeIdlingState
	state_dict["Aggroed"] = %BeAggroState
	state_dict["Charging"] = %BeChargeState
	state_dict["Attacking"] = %BeAttackState
	state_dict["Death"] = %BeDeadState
	state_dict["Hurt"] = %BeHurtState
	state_dict["Stunned"] = %BeStunState
	state_dict["Backing"] = %BeBackState
	state_dict["Laughing"] = %BeLaughState
	
	actor.enemy_died.connect(change_state.bind("Death")) #We connect the signal for when enemy goes into death-state.
	#actor.b_damaged_player.connect(change_state.bind("Backing"))
	super() #Run same code as in overriden function
