#This is the enemy-Kewb's roaming state.
class_name EkRoamingState
extends State #We inherit from our old abstract class, making what's in here a State.

@export var actor: EnemyKewb #We put our "Actor" here, in this case, our enemy-Kewb.
#@export var flip: Marker2D
#@export var animator: AnimationPlayer
#@export var atk_raycast : RayCast2D
#@export var edge_rayL : RayCast2D #Left edge-raycast, to detect where a cliff is.
#@export var edge_rayR : RayCast2D #Right edge-raycast, to detect where a cliff is.

@export var Ewspeed: int = 50 #The walking, aka Roaming -speed.


signal found_player #Signal that sends to rush-state.
signal hurt_roam #Signal that sends to stun-state or dead-state.

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	set_physics_process(false) #We turn off physics, to make sure it's not running before we enter state.

func _enter_state() -> void:
	set_physics_process(true)
	
func _exit_state() -> void:
	set_physics_process(false) #We turn off physics again, when we exit state. (because the next state will turn its own on)

func _physics_process(delta: float) -> void: #FixedUpdate
	actor._apply_gravity(delta)
	_roaming()
	actor._flip() #We run the flip-function in the Actor (enemy-kewb).
	actor._wall_collide(delta) #We check for wall-collisions via the function in Actor. (enemy-kewb)
	_seek_player(delta)
	actor.move_and_slide()

func _roaming():
	actor.animator.play("ek_walk") #We play the walking-animation, using the Actors animator.
	if actor.velocity == Vector2.ZERO: #If our actor isn't moving, then...
		actor.velocity = Vector2.RIGHT.rotated(randf_range(0.0, TAU)) * actor.max_speed #...set our actors velocity to

func _seek_player(_delta):
	if actor.atk_raycast.is_colliding():
		found_player.emit()
		print_debug("Saw player. Exiting Roam.")

#TODO: decide if the below code should be in individual states, or accessed from the Actor.
#func _flip():
	#flip.scale.x = sign(actor.velocity.x) #We make it so our flip's scale is dependent on if the enemy is moving on the x-axis.
	#if flip.scale.x == 0 : #If we're not moving, then...
		#flip.scale.x = 1 #...we flip the scale, aka reverse direction.
	#
	#if !edge_rayL.is_colliding() or !edge_rayR.is_colliding(): #If one of our edge-raycasts aren't detecting...
		#flip.scale.x = -1
#
#func _wall_collide(delta):
	#var collision = actor.move_and_collide(actor.velocity_x * delta)
	#if collision:
		#var bounce_velocity = actor.velocity_x.bounce(collision.get_normal())
		#actor.velocity = bounce_velocity
		
