class_name PlayStateMachine
extends FiniteStateMachine

@export var actor: NewPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#All states except death-state and hurt-state will access take-damage function in main script.
	#Idling, walking, running, airborne will access Get-Input-Velocity
	state_dict["Idling"] = %PlayIdlingState #Play idling-anim, Check for input to change to different states.
	state_dict["Walking"] = #Walking-animation.
	state_dict["Running"] = #Run-animation, faster speed.
	state_dict["Attacking"] = #Attack-animation, give-damage.
	state_dict["Death"] = 
	state_dict["Hurt"] = #Hurt-anim and i-Frames. Can lead to Death-state.
	state_dict["Airborne"] = #Should falling and Jumping be different states?
	state_dict["Charging"] = 
	
	#actor.enemy_died.connect(change_state.bind("Death")) #We connect the signal for when enemy goes into death-state.
	#actor.b_damaged_player.connect(change_state.bind("Backing"))
	super() #Run same code as in overriden function
