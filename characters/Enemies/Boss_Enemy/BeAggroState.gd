class_name BeAggroState
extends State

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.
#@onready var delay_idle : Timer = %BeDelayIdle
#@onready var delay_charge : Timer = %BeDelayCharge
@onready var aggro_delay: Timer = %BeAggroDelay


signal aggro_lost_p
signal start_charging

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	var sm : FiniteStateMachine = get_parent()
	aggro_lost_p.connect(sm.change_state.bind("Idling"))
	#start_charging.connect(sm.change_state.bind("Charging"))
	#Connect a signal to send us to the charging-state.
	
func enter_state() -> void:
	aggro_delay.start()
	actor.animator.play("b_aggro")
	print_debug("Boss entered AGGRO!")

func update_state(delta : float) -> void:
	_aggroing(delta)

func _aggroing(_delta : float):
	if !aggro_delay.is_stopped():
		return
	
	#region Guardclause, to prevent attacking without player.x
	if actor.playerChr == null or GameManager.instance.is_game_over == true: #But if there is no player and game is over, then...
		#print_debug("Player is dead, Boss can't aggro.")
		return #...We don't do anything.
	#endregion
	
	if actor.spot_p_shapecast.is_colliding():
		#delay_charge.start()
		#await delay_charge.timeout
		print_debug("Spotted player, time to charge")
		start_charging.emit() #Send the signal to to go Charging-state.
		
	elif !actor.spot_p_shapecast.is_colliding():
		#delay_idle.start() #Start the timer, so we don't stop aggroing immediately.
		#await delay_idle.timeout #Wait until the timer runs out...
		aggro_lost_p.emit() #...and say we lost the player.

func exit_state() -> void:
	print_debug("Boss exited Aggro")
