#TODO: 

class_name Player
extends CharacterBody2D

#enum CameraLimits {
	#RDCAMLIM, #Right-Direction Camera-Limits 
	#LDCAMLIM #Left-Direction Camera-Limits
#}

const PCMAX_HEALTH : int = 16 #We make a new constant that defines the player has health.
const ACCELERATION : float = 9.8
signal health_updated(new_health : int) #A signal that says our health has changed.
@export var fist_tscn: PackedScene #We make sure that the editor knows the fist-scene/prefab is a scene/prefab.
@export var walking_speed: int = 150
@export var running_speed: int = 300
@export var walk_jump_vel: int = -400
@export var run_jump_vel: int = -600
@export var ch_jump_vel: int = -900

var health : int = PCMAX_HEALTH #We make a new variable based on the Health-constant.
var SPEED: int = 0
var JUMP_VELOCITY: int = 0

var move_dir : Vector2 :
	set(new_dir):
		move_dir = new_dir
var is_grounded : bool = false #Boolean that tells if the player is grounded.
var move_locked : bool = false #Boolean that says if the player can move.
var last_direction = 1.0 #Value that show the direction the player was moving in, last.
var current_direction = 1.0 #Check for the player's current moving direction.
var facing_right: bool = true #This is only for save-games.
#var current_cam_limit = CamLimEnum.E.RDCAMLIM #Right-facing player is default, so camera-limits Right is also default.
var current_move_state = PcMoveStaEnum.E.IDLE #We make a new var to describe the basic state...Idle.
var current_anim_state = PcAnimEnum.E.PAIDLE
var anim : AnimationPlayer
var fist_time : Timer
var fist_point : Marker2D
var dead_time : Timer
var player_cam : Camera2D
var charge_jmp_time: Timer


#Ability Vars -- they decide if the player can access their abilities.
var charge_jump : bool = false
var power_punch : bool = false
var upper_cut : bool = false

static var instance : Player


func _init() -> void:
	instance = self
	
func _ready() -> void:
	player_cam = %PlayerCamera
	anim = %AnimationPlayer
	fist_time = %FistTime #We get the timer that decides how long our fist is visible
	fist_point = %FistPoint
	dead_time = %PDeadTimer
	charge_jmp_time = %ChaJmpTimer
	#Wait... do I need to connect this to an animation-state as well?? YES! >:( 
	current_direction = -1 #We set the direction the player is facing, at the start of the game (to be right).
	await get_tree().process_frame
	health_updated.emit(health)
	if GameManager.instance.player_hidden == false:
		free_movement() #We unlock movement when the player loads in.
	else:
		pass

func _input(event: InputEvent) -> void:
	#Below, we create a variable that determines the direction of the player, based on the 
	#input from our movement-actions.
	move_dir.x = Input.get_axis("move_left", "move_right")
	move_dir.y = Input.get_axis("move_up", "move_down")
	#STATE CHECK, IF MOVE DIR STATE IS WALKING; ELSE IDLE
	if move_dir.x != 0.0:
		current_move_state = PcMoveStaEnum.E.WALKING
	else:
		current_move_state = PcMoveStaEnum.E.IDLE
		
	flip() #We run the flip-sprite function if we're moving.
	_player_attack() #If we press attack we run the player attack function.
	
	#If we're holding charge while walking, and moving, then...
	if Input.is_action_pressed("charge") and move_dir.x:
		#print_debug("player is running")
		current_move_state = PcMoveStaEnum.E.RUNNING #...we start running.
		
	#Debug-stuff
	if event.is_action_pressed("kill_player"):
		health = 0
		print_debug("Debug-Killed player.")
	
func _player_attack():
	#region Guardclause
	if !Input.is_action_just_pressed("attack"): #Nothing will happen if an attack command did not happen
		return
	#endregion
	
	#Regular attack
	#if Input.is_action_just_pressed("attack") and fist_time.is_stopped(): #If the player just pressed attack, and the fist-timer hasn't started...
	if Input.is_action_just_pressed("attack") and !Input.is_action_pressed("charge") and fist_time.is_stopped():
		var fist = fist_tscn.instantiate()
		fist_point.add_child(fist)
		fist_time.start()
		fist.fist_anim.play("norm_fist") #We make the fists animator play the normal punch-animation.
		print_debug("Player attacked!")
		await fist_time.timeout
		fist.queue_free()
		
	#Power Punch
	#If we pressed attack while holding charge and we have the power-punch upgrade and we haven't started punching before...
	if power_punch == true and Input.is_action_pressed("charge") and Input.is_action_just_pressed("attack") and fist_time.is_stopped(): 
		var pow_fist = fist_tscn.instantiate()
		fist_point.add_child(pow_fist)
		fist_time.start()
		pow_fist.fist_anim.play("power_fist")
		print_debug("Power-Punch!")
		await fist_time.timeout
		pow_fist.queue_free()
		
#Physics Process Delta is a fixed Update, happens 60/1.
func _physics_process(delta: float) -> void: #I picked physics, since this is movement.
	#--Guard-clause, if we're not supposed to move, then we can't use the controls.
	if move_locked: #If the move_locked bool has become true (i.e we're in a locked state)...
		return #...then don't do the below stuff.
	#--Guard-clause END.
	
	# Add the gravity.
	_apply_gravity(delta)
	_jumping(delta)
	apply_movement(delta) #We run the movement-state switch.
	update_animation(delta) #We update the animation.
	#camera_control() #We adjust the camera.
	move_and_slide()

func _jumping(_delta: float) -> void:
		# Player presses jump -> Kewb jumps.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = walk_jump_vel
		current_anim_state = PcAnimEnum.E.PAJUMP
		_unground_player() #We make sure to say the player isn't grounded.
		#print_debug("Player jumped")
	#Jump higher
	if Input.is_action_just_pressed("jump") and Input.is_action_pressed("charge") and is_on_floor(): #If we're also holding charge...
		velocity.y = run_jump_vel 
		current_anim_state = PcAnimEnum.E.PAJUMP
		_unground_player()
		#print_debug("Player jumped higher")
	
	if charge_jump == true and Input.is_action_pressed("charge") and Input.is_action_pressed("jump") and charge_jmp_time.is_stopped(): 
		charge_jmp_time.start()
		print_debug("Charging Jump!")
		current_anim_state = PcAnimEnum.E.PACHJMP #We run the charge-jump animation...
		await charge_jmp_time.timeout #...until the charging is done
		velocity.y = run_jump_vel #Then we increase jump-velocity tons
		current_anim_state = PcAnimEnum.E.PAJUMP

func apply_movement(delta : float): #Let's do a switch, aka a match, instead of 10k if-statements.
	match current_move_state :
		PcMoveStaEnum.E.IDLE: #This would be a "case" in Unity.
			velocity.x = (0.0)
			_apply_gravity(delta)
			current_anim_state = PcAnimEnum.E.PAIDLE
		PcMoveStaEnum.E.WALKING:
			velocity.x = (move_dir * walking_speed).x #When walking our velocity should be the input from move_dir
			_apply_gravity(delta)
			current_anim_state = PcAnimEnum.E.PAWALK
		PcMoveStaEnum.E.RUNNING:
			velocity.x = (move_dir * running_speed).x
			_apply_gravity(delta)
			current_anim_state = PcAnimEnum.E.PARUN
			#print_debug("Running!")
		PcMoveStaEnum.E.AIRBORNE:
			pass
		PcMoveStaEnum.E.UNDERWATER:
			pass

func update_animation(_delta): #This is where we change which anim we're in.
	match current_anim_state :
		PcAnimEnum.E.PAIDLE: #This would be a "case" in Unity.
			anim.play("player_idle")
		PcAnimEnum.E.PAWALK:
			anim.play("player_walk")
			#print_debug("Playing Walk-Animation.")
		PcAnimEnum.E.PARUN:
			pass
		PcAnimEnum.E.PAJUMP:
			anim.play("player_jump")
		PcAnimEnum.E.PASWIM:
			pass
		PcAnimEnum.E.PAPUNCH:
			pass
		PcAnimEnum.E.PACHJMP:
			anim.play("player_charge_jump")
		PcAnimEnum.E.PADEAD:
			anim.play("player_dead")
			print_debug("Playing Player Death-animation.")
	
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
		velocity.y += gravity.y * delta
	
	else: #Otherwise, we...
		return #...don't do anything. (no gravity-application)
	
func take_damage(damage : int):
	health -= damage #Player's health decreases according to variable, per punch that connects.
	print("Player Took Damage!")
	health_updated.emit(health)
	if health <= 0: #If you run out of health, or if it goes negative, then...
		lock_movement() #We lock the player, so it doesn't move around.
		dead_time.start() #We start a timer that's supposed to let our DEATH-ANIMATION play.
		print_debug("running dead-timer")
		while !dead_time.is_stopped(): #For as long as the back-off-timer is running...
			#Make the enemy back off after damaging the player.
			current_anim_state = PcAnimEnum.E.PADEAD #We set the current animation-state to DEAD. ( we play the death-animation)
			await get_tree().process_frame
		print_debug("Player died.")
		GameManager.instance.is_game_over = true
		GameManager.instance.change_gui_scene("GameOverScreen", false, false, true) #Run the game-over screen
		self.queue_free() #...destroy the Player by removing from memory.
		
#Code to flip the character when walking.
func flip():
	#Guard clause
	if move_dir.x == 0:
		return
	#END Guard clause
	var signed_x : float = sign(move_dir.x) #A variable that stores if the direction is positive or negative.
	%Flip.scale.x = abs(scale.x) *  signed_x
	current_direction = signed_x
	var dir_string : String = "_left" if signed_x == -1.0 else "_right"
	
	if dir_string == "_left":
		facing_right = false
	elif dir_string == "_right":
		facing_right = true
	
	if current_direction != last_direction: #If the current direction is not the same as the last direction, then...
		$CamAnimationPlayer.play("cam_mov" + dir_string) #Then move/animate the camera in the new direction.
		
	#Update the last direction variable.
	last_direction = current_direction
	
func _ground_player():
	is_grounded = true
	velocity.y = walk_jump_vel #Make sure player looses ability to jump high.
	print_debug("Grounded player.")
	
func _unground_player():
	is_grounded = false
	#print_debug("Ungrounded player.")
	
#region the below functions enables the upgrade-abilities
func enable_powerpunch():
	power_punch = true
	print_debug("Player got the Power-Punch!")
	
func enable_chargejump():
	charge_jump = true
	print_debug("Player got the Charge-jump!")
	
func enable_uppercut():
	upper_cut = true
	print_debug("Player got the Upper-Cut!")

#endregion

	#Pseudo-code: 
	#Constant acceleration
	#pos += velocity * delta-time + 1/2 acceleration * delta-time * delta-time
	#Simplified, almost as good:
	#delta-acceleration * delta-time * delta-time
	#A curve to apply it?
#func _jump(delta):
	#self.position += (velocity * delta) + ((0.5 * ACCELERATION) * delta * delta)
	#velocity += ACCELERATION * delta
