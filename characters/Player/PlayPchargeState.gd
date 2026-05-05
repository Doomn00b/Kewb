class_name PlayPchargeState
extends State

signal unleash_p_punch

@export_category("Put Actor, aka Player-prefab here")
@export var actor: NewPlayer #We put our "Actor" here, in this case, our Player-kewb.

var full_p_charge : bool = false
var p_charge_time : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	var sm : FiniteStateMachine = get_parent()
	unleash_p_punch.connect(sm.change_state.bind("Attack")) #We connect the found player signal to activate the rush state
	
func enter_state() -> void:
	print_debug("Player entered Punch Charge-state.")
func update_state(delta : float) -> void:
	_pcharging(delta)

func _pcharging(delta):
	if actor.instance.power_punch == true and Input.is_action_pressed("attack"):
		p_charge_time += 0.1 * delta
		print_debug("We have held punch-charge for:" , p_charge_time)
		
	elif Input.is_action_just_released("charge") and full_p_charge:
		pass

func exit_state() -> void:
	print_debug("Player exit Punch-charge")
