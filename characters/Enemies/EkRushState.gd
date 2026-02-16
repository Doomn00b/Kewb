extends State
class_name EkRushState

@export var actor: EnemyKewb #We put our "Actor" here, in this case, our enemy-Kewb.
@export var Erunspeed: int = 50 #The walking, aka Roaming -speed.

var delay_rush : Timer #This variable is the time between spotting the player and attacking.

signal lost_player #Signal that sends to roam-state.
signal hurt_rush #Signal that sends to stun-state or dead-state.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sm : FiniteStateMachine = get_parent()
	lost_player.connect(sm.change_state.bind("Roaming")) #We connect a signal which triggers Roaming-state.

func enter_state() -> void:
	delay_rush = %RushDelay #When we enter rush-state, we get the rush-delay timer.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_state(delta : float) -> void:
	#actor.take_damage(delta)
	actor.apply_gravity(delta)
	_rush_player(delta)
	actor.flip()
	actor.move_and_slide()
	
func _rush_player(_delta : float):
	#Guardclause, to prevent attacking without player.
	if actor.playerChr == null or GameManager.instance.is_game_over == true: #But if there is no player and game is over, then...
		print_debug("Player is dead, Enemy won't attack.")
		return #...We don't do anything.
	if !delay_rush.is_stopped():
		return
	#END guard-clause
	
	if actor.atk_raycast.is_colliding(): #If the raycast hits the player...
		delay_rush.start() #...we start a timer to delay the 1st attack.
		await delay_rush.timeout #...which delays the below attack-code.
		if actor.is_on_floor() and GameManager.instance.is_game_over == false : #If the actor (EnemyKewb) is on the floor and it's not game over, then...
			actor.animator.play("ek_rush") #We play the rush-animation
			actor.move_dir = (actor.playerChr.position - actor.position).normalized()
			actor.velocity.x = actor.move_dir.x * Erunspeed
			return
	elif !actor.atk_raycast.is_colliding(): #If the raycast can't see the player, then...
		lost_player.emit() #...emit the signal to change state.
		print_debug("Lost the player.")

func exit_state() -> void:
	print_debug("Exiting RUSH.")
