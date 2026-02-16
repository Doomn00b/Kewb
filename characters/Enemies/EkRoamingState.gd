#This is the enemy-Kewb's roaming state.
class_name EkRoamingState
extends State #We inherit from our old abstract class, making what's in here a State.

@export var actor: EnemyKewb #We put our "Actor" here, in this case, our enemy-Kewb.
@export var Ewspeed: int = 50 #The walking, aka Roaming -speed.

signal found_player #Signal that sends to rush-state.
signal hurt_roam #Signal that sends to stun-state or dead-state.

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	var sm : FiniteStateMachine = get_parent()
	found_player.connect(sm.change_state.bind("Rush")) #We connect the found player signal to activate the rush state
	
func enter_state() -> void:
	pass
	
func exit_state() -> void:
	print_debug("Exiting Roaming")

func update_state(delta: float) -> void: #FixedUpdate
	#actor.take_damage(delta)
	actor.apply_gravity(delta)
	_roaming()
	actor.flip() #We run the flip-function in the Actor (enemy-kewb).
	actor.wall_collide(delta) #We check for wall-collisions via the function in Actor. (enemy-kewb)
	_seek_player(delta)
	actor.move_and_slide()

func _roaming():
	actor.animator.play("ek_walk") #We play the walking-animation, using the Actors animator.
	if actor.velocity == Vector2.ZERO: #If our actor isn't moving, then...
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0.0, TAU)) * actor.max_speed #...set our actors velocity to

func _seek_player(_delta):
	if actor.atk_raycast.is_colliding(): #If our attack-raycast is colliding, then...
		found_player.emit() #...emit the signal that we've found the player.
		print_debug("Saw player. Exiting Roam.")
