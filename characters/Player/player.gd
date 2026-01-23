#BEST PRACTICES:
#Get input in _process and save results to member variables.
#→Detects input every frame for smooth controls.


class_name Player
extends CharacterBody2D

@export var fist_tscn: PackedScene #We make sure that the editor knows the fist-scene/prefab is a scene/prefab.

const SPEED: int = 300
const JUMP_VELOCITY: int = -400

var move_dir : Vector2
#var player_pos : Transform2D
var is_grounded : bool = false #Boolean that tells if the player is grounded.
var move_locked : bool = false #Boolean that says if the player can move.

var walking_speed: int = 150
var running_speed: int = 300

 #These enums define the different movement-states player can have.
enum MovementState {
	IDLE,
	WALKING,
	RUNNING,
	AIRBORNE,
	UNDERWATER
}
var current_state = MovementState.IDLE #We make a new var to describe the basic state...Idle.

func _process(_delta: float) -> void: #Happens on every frame.
	#Below, we create a variable that determines the direction of the player, based on the 
	#input from our movement-actions.
	move_dir = Input.get_vector("move_back", "move_forward", "move_up", "move_down") 
	
	if Input.is_action_pressed("charge"):
		print_debug("player is holding charge")
		#If we're holding charge while walking, and not running, then...
		if MovementState.WALKING and not MovementState.RUNNING:
			current_state = MovementState.RUNNING #...we start running.
		elif Input.is_action_just_pressed("attack"):
			pass #Replace with power-punch!
			
	# pseudocode - Player presses punch -> do punching-fist. (animation? Spawn arm?)
	if Input.is_action_just_pressed("attack"): #If the player presses the shoot-action, then...
		print_debug("Player attacked!")
	
	#Visual processing, stuff like animation updates.
	update_animation() 

#Physics Process Delta is a fixed Update, happens 60/1.
func _physics_process(delta: float) -> void: #I picked physics, since this is movement.
	
	#--Guard-clause, if we're not supposed to move, then we can't use the controls.
	if move_locked: #If the move_locked bool has become true (i.e we're in a locked state)...
		return #...then don't do the below stuff.
	#--Guard-clause END.
	
	# Add the gravity.
	_apply_gravity(delta)

	# Player presses jump -> Kewb jumps.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		unground_player() #We make sure to say the player isn't grounded.
		print_debug("Player jumped")


	# Get the input direction and handle the movement/deceleration.
	if move_dir :
		#velocity = move_dir * SPEED
		velocity.x = move_dir.x * SPEED
		#velocity.y = move_dir.y * SPEED
		print_debug("Player moved")
	else:
		#velocity = move_toward(0, 0, SPEED)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	
	apply_movement() #We run the movement-state switch.
	move_and_slide()

		
#These functions are called to turn on and off movement.
func lock_movement():
	move_locked = true #Turn off movement.
	print_debug("Turned off movement.")
func free_movement():
	move_locked = false #Turn on movement.
	print_debug("Turned ON movement.")

func ground_player():
	is_grounded = true
	
func unground_player():
	is_grounded = false


func _apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity()
		#velocity += gravity * delta
		velocity.y += gravity.y * delta
		#velocity.x += gravity.x * delta
	
	else: #Otherwise, we...
		return #...don't do anything. (no gravity-application)
	
func apply_movement(): #Let's do a switch, aka a match, instead of 10k if-statements.
	match MovementState :
		MovementState.IDLE: #This would be a "case" in Unity.
			pass
		MovementState.WALKING:
			pass
		MovementState.RUNNING:
			pass
		MovementState.AIRBORNE:
			pass
		MovementState.UNDERWATER:	
			pass
			
func update_animation(): #This is where we change which anim we're in.
	pass

#The below is for killing the player.
func _on_area_entered(_enemyArea: Area2D) -> void: #If something tagged _enemyArea enters the plater-ships collider, then..
	if _enemyArea.is_in_group("enemyGroup"):
		self.queue_free() #...destroy the Player by removing from memory.
		print_debug("Player died.")
		GameState.is_game_over = true
