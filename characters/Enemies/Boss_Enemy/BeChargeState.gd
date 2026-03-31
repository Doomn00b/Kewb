class_name BeChargeState
extends State

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.
@onready var delay_charge : Timer = %BeDelayCharge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
 
func enter_state() -> void:
	delay_charge.start()
	await delay_charge.timeout

func update_state(_delta : float) -> void:
	if !%BeDelayCharge.is_stopped():
		return
	#Charge Code Here
	charging()
	
func charging():
	#Once the charging-animation is over, we run the signal to go to attack.
	actor.animator.play("b_charging")
	pass
	
func exit_state() -> void:
	print_debug("Boss stopped charging.")
