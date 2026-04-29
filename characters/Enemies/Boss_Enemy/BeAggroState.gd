class_name BeAggroState
extends State

signal aggro_lost_p
signal start_charging

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.
@onready var aggro_delay: Timer = %BeAggroDelay

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	var sm : FiniteStateMachine = get_parent()
	aggro_lost_p.connect(sm.change_state.bind("Idling")) #Losing the player will send Boss to idle.
	start_charging.connect(sm.change_state.bind("Charging")) #This will send Boss to charge up a blow.
	#Connect a signal to send us to the charging-state.
	
func enter_state() -> void:
	print_debug("Boss entered AGGRO!")
	aggro_delay.start()

func update_state(delta : float) -> void:
	_aggroing(delta)

func _aggroing(_delta : float):
	if !aggro_delay.is_stopped(): #If the aggro-delay timer hasn't stopped...
		return #...we do nothing.
	actor.animator.play("b_aggro") #We play the aggro-ed animation.
	
	#region Guardclause, to prevent attacking without player.x
	if actor.playerChr == null or GameManager.instance.is_game_over == true: #But if there is no player and game is over, then...
		#print_debug("Player is dead, Boss can't aggro.")
		return #...We don't do anything.
	#endregion
	
	if actor.spot_p_shapecast.is_colliding(): #If the shape looking for player is colliding...
		print_debug("Spotted player, time to charge")
		start_charging.emit() #Send the signal to go to Charging-state.
		
	elif !actor.spot_p_shapecast.is_colliding(): #...but if it's not colliding...
		aggro_lost_p.emit() #...say we lost the player.

func exit_state() -> void:
	print_debug("Boss exited Aggro")
