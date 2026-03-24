extends State
class_name EkBackingState
@export_category("Put Actor, aka Enemy-prefab here")
@export var actor: EnemyKewb #We put our "Actor" here, in this case, our enemy-Kewb.
@export var Erunspeed: int = 50 #The walking, aka Roaming -speed.

signal done_backing #Signal that sends to roam-state.
signal hurt_backing #Signal that sends to stun-state or dead-state.

@onready var backoff_time : Timer = %EbackTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sm : FiniteStateMachine = get_parent()
	done_backing.connect(sm.change_state.bind("Roaming")) #We connect the signal to send us back to roaming 
														  #(which could then go to rushing if the player is still in range
func enter_state() -> void:
	_back_off()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_state(_delta : float) -> void:
	pass
	#actor.take_damage(delta)
	#actor.apply_gravity(delta)
	#actor.flip()
	#actor.move_and_slide()
	
func _back_off():
	backoff_time.start()
	print_debug("running backoff-timer")
	while !backoff_time.is_stopped(): #For as long as the back-off-timer is running...
		#Make the enemy back off after damaging the player.
		actor.velocity.x = actor.max_walk_speed #Enemy moves backwards at walk-speed.
		await get_tree().process_frame
		#print_debug("Enemy back-speed:", actor.velocity_x)
	done_backing.emit() #emit the signal that takes us to the next state.

func exit_state() -> void:
	print_debug("Exiting BACKING.")
