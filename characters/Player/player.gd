#BEST PRACTICES:
#Get input in _process and save results to member variables.
#→Detects input every frame for smooth controls.


class_name Player
extends CharacterBody2D

enum MovementState {
	IDLE,
	WALKING,
	RUNNING,
	AIRBORNE,
	UNDERWATER
}

enum AnimationState {
	PAIDLE,
	PAWALK,
	PARUN,
	PAJUMP,
	PASWIM,
	PADEAD
}
const JUMP_VELOCITY: int = -400

@export var fist_tscn: PackedScene #We make sure that the editor knows the fist-scene/prefab is a scene/prefab.

var SPEED: int = 0

var move_dir : Vector2
#var player_pos : Transform2D
var is_grounded : bool = false #Boolean that tells if the player is grounded.
var move_locked : bool = false #Boolean that says if the player can move.

var walking_speed: int = 150
var running_speed: int = 300

var current_move_state = MovementState.IDLE #We make a new var to describe the basic state...Idle.
var current_anim_state = AnimationState.PAIDLE
#These enums define the different movement-states player can have.

#@onready var anim : AnimationPlayer = %AnimationPlayer

var anim : AnimationPlayer

func _ready() -> void:
	anim = %AnimationPlayer

func _input(event: InputEvent) -> void:
	#Below, we create a variable that determines the direction of the player, based on the 
	#input from our movement-actions.
	move_dir.x = Input.get_axis("move_back", "move_forward")
	move_dir.y = Input.get_axis("move_up", "move_down")
	#STATE CHECK, IF MOVE DIR STATE IS WALKING; ELSE IDLE
	if move_dir.x != 0.0:
		current_move_state = MovementState.WALKING
	else:
		current_move_state = MovementState.IDLE
		
	_flip() #We run the flip-sprite function if we're moving.
	
	#If we're holding charge while walking, and moving, then...
	if Input.is_action_pressed("charge") and move_dir.x:
		print_debug("player is holding charge")
		current_move_state = MovementState.RUNNING #...we start running.
		
	# pseudocode - Player presses punch -> do punching-fist. (animation? Spawn arm?)
	if Input.is_action_just_pressed("attack"): #If the player presses the shoot-action, then...
		print_debug("Player attacked!")
		if Input.is_action_pressed("charge") and Input.is_action_just_pressed("attack"):
			#Replace with power-punch!
			print_debug("Power-punch!")
	
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
		_unground_player() #We make sure to say the player isn't grounded.
		print_debug("Player jumped")
	
	apply_movement(delta) #We run the movement-state switch.
	update_animation() 
	move_and_slide()

func apply_movement(delta : float): #Let's do a switch, aka a match, instead of 10k if-statements.
	
	match current_move_state :
		MovementState.IDLE: #This would be a "case" in Unity.
			velocity.x = (0.0)
			_apply_gravity(delta)
			current_anim_state = AnimationState.PAIDLE
		MovementState.WALKING:
			#SPEED = walking_speed
			velocity.x = (move_dir * walking_speed).x #When walking our velocity should be the input from move_dir
			_apply_gravity(delta)
			current_anim_state = AnimationState.PAWALK
		MovementState.RUNNING:
			#SPEED = running_speed
			velocity.x = (move_dir * running_speed).x
			_apply_gravity(delta)
			current_anim_state = AnimationState.PARUN
			print_debug("Running!")
			
		MovementState.AIRBORNE:
			pass
		MovementState.UNDERWATER:
			pass

func update_animation(): #This is where we change which anim we're in.
	match current_anim_state :
		AnimationState.PAIDLE: #This would be a "case" in Unity.
			anim.play("player_idle")
		AnimationState.PAWALK:
			anim.play("player_walk")
		AnimationState.PARUN:
			pass
		AnimationState.PAJUMP:
			pass
		AnimationState.PASWIM:
			pass
		AnimationState.PADEAD:
			anim.play("player_dead")
	

#These functions are called to turn on and off movement.
func lock_movement():
	move_locked = true #Turn off movement.
	print_debug("Turned off movement.")
func free_movement():
	move_locked = false #Turn on movement.
	print_debug("Turned ON movement.")

func _apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity()
		#velocity += gravity * delta
		velocity.y += gravity.y * delta
		#velocity.x += gravity.x * delta
	
	else: #Otherwise, we...
		return #...don't do anything. (no gravity-application)
	
#The below is for killing the player.
func _on_area_entered(_enemyArea: Area2D) -> void: #If something tagged _enemyArea enters the plater-ships collider, then..
	if _enemyArea.is_in_group("enemyGroup"):
		self.queue_free() #...destroy the Player by removing from memory.
		print_debug("Player died.")
		GameState.is_game_over = true
		
#Code to flip the character when walking.
func _flip():
	if sign(move_dir.x) == -1: #If we input movement to the left on the x-axis (negative), then...
		%Flip.scale.x = abs(scale.x) * -1.0 #...we flip the player using absolute scale.
	elif sign(move_dir.x) == +1 :
		%Flip.scale.x = abs(scale.x) * +1.0
	#if move_dir.x != 0:
		#var new_scale : float = abs(scale.x) * sign(move_dir.x)
		#scale.x = new_scale

func _ground_player():
	is_grounded = true
	
func _unground_player():
	is_grounded = false
