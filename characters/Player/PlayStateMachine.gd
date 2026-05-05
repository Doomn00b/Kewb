class_name PlayStateMachine
extends FiniteStateMachine

@export var actor: NewPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#All states except death-state and hurt-state will access take-damage function in main script.
	#Idling, walking, running, airborne will access Get-Input-Velocity
	state_dict["Idling"] = %PlayIdlingState #Play idling-anim, Check for input to change to different states.
	state_dict["Walking"] = %PlayWalkState #Walking-animation.
	state_dict["Running"] = %PlayRunState #Run-animation, faster speed.
	state_dict["Death"] = %PlayDeadState
	state_dict["Hurt"] = %PlayHurtState #Hurt-anim and i-Frames. Can lead to Death-state.
	state_dict["Jumping"] = %PlayJumpState #Should falling and Jumping be different states?
	state_dict["Attacking"] = %PlayAtkState #Attack-animation, give-damage.
	state_dict["Punch-charging"] = %PlayPchargeState #Power-Punch charge-animation
	state_dict["Jump-charging"] = %PlayJchargeState #Charge-Jump animation
	
	actor.player_died.connect(change_state.bind("Death")) #We connect the signal for when enemy goes into death-state.
	actor.health_updated.connect(change_state.bind("Hurt")) #If the player emits that health has been changed, it goes into hurt-state.
	super() #Run same code as in overriden function
