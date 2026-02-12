extends State
class_name EkRushState

@export var actor: EnemyKewb #We put our "Actor" here, in this case, our enemy-Kewb.
@export var Erunspeed: int = 50 #The walking, aka Roaming -speed.

#@export var flip: Marker2D
#@export var animator: AnimationPlayer
#@export var atk_raycast : RayCast2D
#@export var edge_rayL : RayCast2D #Left edge-raycast, to detect where a cliff is.
#@export var edge_rayR : RayCast2D #Right edge-raycast, to detect where a cliff is.
var delay_rush : Timer #This variable is the time between spotting the player and attacking.

signal lost_player #Signal that sends to roam-state.
signal hurt_rush #Signal that sends to stun-state or dead-state.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	delay_rush = $"../../RushDelay"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_rush_player(delta)
	actor._flip()
	
func _rush_player(_delta : float):
	#Guardclause, to prevent attacking without player.
	if actor.playerChr == null or GameManager.instance.is_game_over == true: #But if there is no player and game is over, then...
		print_debug("Player is dead, Enemy won't attack.")
		return #...We don't do anything.
	if !delay_rush.is_stopped():
		return
	#END guard-clause
	
	#Raycasting, for detecting the player.
	if actor.atk_raycast.is_colliding(): #If the raycast hits the player...
		delay_rush.start() #...we start a timer to delay the 1st attack.
		await delay_rush.timeout #...which delays the below attack-code.
		#If the enemy is touching the floor and we're not in Game Over, then...
		if actor.is_on_floor() and GameManager.instance.is_game_over == false : #If the actor (EnemyKewb) is on the floor and it's not game over, then...
			actor.move_dir = (actor.playerChr.position - actor.position).normalized()
			actor.velocity.x = actor.move_dir.x * Erunspeed
			return
	elif !actor.atk_raycast.is_colliding(): #If the raycast can't see the player, then...
		lost_player.emit() #...emit the signal to change state.

#func _flip():
	#flip.scale.x = sign(actor.velocity.x) #We make it so our flip's scale is dependent on if the enemy is moving on the x-axis.
	#if flip.scale.x == 0 : #If we're not moving, then...
		#flip.scale.x = 1 #...we flip the scale, aka reverse direction.
	#
	#if !actor.edge_rayL.is_colliding() or !actor.edge_rayR.is_colliding(): #If one of our edge-raycasts aren't detecting...
		#flip.scale.x = -1

func _exit_state() -> void:
	set_physics_process(false)
