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

enum CameraLimits {
	RDCAMLIM, #Right-Direction Camera-Limits 
	LDCAMLIM #Left-Direction Camera-Limits
}

const JUMP_VELOCITY: int = -400
const PCMAX_HEALTH = 10 #We make a new constant that defines the enemy has health.

@export var fist_tscn: PackedScene #We make sure that the editor knows the fist-scene/prefab is a scene/prefab.

var health = PCMAX_HEALTH #We make a new variable based on the Health-constant.
var SPEED: int = 0

var move_dir : Vector2 :
	set(new_dir):
		move_dir = new_dir
#var player_pos : Transform2D
var is_grounded : bool = false #Boolean that tells if the player is grounded.
var move_locked : bool = false #Boolean that says if the player can move.

var walking_speed: int = 150
var running_speed: int = 300

var last_direction = 1 #Value that show the direction the player was moving in, last.
var current_direction = 1 #Check for the player's current moving direction.
var current_cam_limit = CameraLimits.RDCAMLIM #Right-facing player is default, so camera-limits Right is also default.

var current_move_state = MovementState.IDLE #We make a new var to describe the basic state...Idle.
var current_anim_state = AnimationState.PAIDLE
#These enums define the different movement-states player can have.

#@onready var anim : AnimationPlayer = %AnimationPlayer

var anim : AnimationPlayer

func _ready() -> void:
	anim = %AnimationPlayer
	#We set the direction the player is facing, at the start of the game (to be right).
	current_direction = -1 

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
		
	 #We run the flip-sprite function if we're moving.
	_flip()
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
	update_animation() #We update the animation.
	#camera_control() #We adjust the camera.
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
func _on_detection_area_entered(_enemyArea: Area2D) -> void:
	if _enemyArea.is_in_group("enemyGroup"):
		health -= 5 #Player's health decreases by 5, per punch that connects.
		print("Got punched by the Enemy!")
		if health <= 0: #If you run out of health, or if it goes negative, then...
			self.queue_free() #...destroy the Player by removing from memory.
			print_debug("Player died.")
			GM.is_game_over = true

		
#Code to flip the character when walking.
func _flip():
	#Guard clause
	if move_dir.x == 0:
		return
	var signed_x : float = sign(move_dir.x)
	%Flip.scale.x = abs(scale.x) *  signed_x
	current_direction = signed_x
	var dir_string : String = "_left" if signed_x == -1 else "_right"
	
	if current_direction != last_direction:
		$CamAnimationPlayer.play("cam_mov" + dir_string)
		
	#Update the last direction variable.
	last_direction = current_direction
	
#func camera_control():
	#match CameraLimits :
		#CameraLimits.RDCAMLIM: #Right-Direction Camera-Limits 
			#$Camera2D.limit_left = -90 #10 pixels more than camera-offset.
			#$Camera2D.limit_bottom = 328 #40 pixels more than ref-rez Y.
			#$Camera2D.limit_top = 30 #10 pixels less than camera-offset.
			#$Camera2D.limit_right = 432 #80 pixels less than ref-rez X.
			#print_debug("Set Right Camlimits")
			#
		#CameraLimits.LDCAMLIM: #Left-Direction Camera-Limits
			#$Camera2D.limit_left = 70 #10 pixels LESS than camera-offset.
			#$Camera2D.limit_bottom = 328 #40 pixels more than ref-rez Y.
			#$Camera2D.limit_top = 30 
			#$Camera2D.limit_right = 592 #80 pixels more than ref-rez X.
			#print_debug("Set LEFT Camlimits")

func _ground_player():
	is_grounded = true
	
func _unground_player():
	is_grounded = false
