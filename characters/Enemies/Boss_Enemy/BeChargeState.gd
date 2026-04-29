class_name BeChargeState
extends State

signal b_charge_done

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.
@onready var delay_charge : Timer = %BeDelayCharge
@onready var charge_time : Timer = %BeChargeTime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sm : FiniteStateMachine = get_parent()
	b_charge_done.connect(sm.change_state.bind("Attacking"))
 
func enter_state() -> void:
	delay_charge.start()
	print_debug("Boss entered Charge-state.")
	await delay_charge.timeout
	charging()
	while !charge_time.is_stopped() and actor.animator.is_playing(): #We wait for the timer to run down and animation to complete
		await get_tree().process_frame #The while loop keeps us from emitting charge done.
	b_charge_done.emit()
	

func update_state(_delta : float) -> void:
	pass
	#print_debug("Boss charge Update start")
	#if !delay_charge.time_left == 0:
		#return
	#else:
		#pass
	##if !delay_charge.is_stopped(): #If the delay to charge isn't done, then...
		##return #...do nothing.
	##Charge Code Here
	#charging()
	#print_debug("Boss charge update END.")
	#
func charging():
	#Once the charging-animation is over, we run the signal to go to attack.
	actor.animator.play("b_charging")
	#NOTE: do I need to change is_playing to INDEX done or some such??
	if !charge_time.is_stopped() and actor.animator.is_playing(): #We wait for the timer to run down and animation to complete
		return

	
func exit_state() -> void:
	print_debug("Boss stopped charging.")
