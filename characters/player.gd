extends CharacterBody2D

@export var fist_tscn: PackedScene #We make sure that the editor knows the fist-scene/prefab is a scene/prefab.

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var move_dir : Vector2
var player_pos : Transform2D
var is_grounded : bool = false #Boolean that tells if the player is grounded.
var move_locked : bool = false #Boolean that says if the player can move.

#Physics Process Delta is a fixed Update, happens 60/1.
func _physics_process(_delta: float) -> void: #I picked physics, since this is movement.
	
	player_pos = self.Transform2D #We create a new variable based on this objects Transform2D.
	
	#Guard-clause, if we're not supposed to move, then we can't use the controls.
	if move_locked: #If the move_locked bool has become true (i.e we're in a locked state)...
		return #...then don't do the below stuff.
	#Guard-clause END.
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	# Player presses jump -> Kewb jumps.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("Player jumped")

	#Below, we create a variable that determines the direction of the player, based on the 
	#input from our movement-actions.
	# Get the input direction and handle the movement/deceleration.
	move_dir = Input.get_vector("move_back", "move_forward", "move_down", "move_up") 
	if move_dir:
		velocity.x = move_dir.x * SPEED
		velocity.y = move_dir.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
#END godots own	
	
	
	
	if Input.is_action_pressed("charge"):
		print("player is holding charge")
		pass

	# pseudocode - Player presses punch -> do punching-fist. (animation? Spawn arm?)
	if Input.is_action_just_pressed("attack"): #If the player presses the shoot-action, then...
		print("Player attacked!")
		
		#The below may need to be revised... since it's probably better to make this an animation.
		var new_fist = fist_tscn.instantiate()
		add_child(new_fist) #We make the fist a child of the player (it belongs to him).
		new_fist.position = self.position #We make the laser-children spawn at the player-ship.
		pass
		

func _process(_delta: float) -> void: #Happens on every frame.
	pass

#These functions are called to turn on and off movement.
func lock_movement():
	move_locked = true #Turn off movement.
func free_movement():
	move_locked = false #Turn on movement.


#The below is for killing the player.
func _on_area_entered(_enemyArea: Area2D) -> void: #If something tagged _enemyArea enters the plater-ships collider, then..
	if _enemyArea.is_in_group("enemyGroup"):
		self.queue_free() #...destroy the Player by removing from memory.
		
		GameState.is_game_over = true
