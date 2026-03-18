class_name EnemyStateMachine
extends FiniteStateMachine

@export var actor: EnemyKewb

func _ready() -> void:
	state_dict["Roaming"] = %EkRoamingState
	state_dict["Rush"] = %EkRushState
	state_dict["Death"] = %EkDeathState
	state_dict["Backing"] = %EkBackingState
	actor.enemy_died.connect(change_state.bind("Death")) #We connect the signal for when enemy goes into death-state.
	actor.damaged_player.connect(change_state.bind("Backing"))
	super() #Run same code as in overriden function
