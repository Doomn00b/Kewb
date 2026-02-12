#TODO: Make enemy flip direction when Walking to edge.
		#Fix chasing the player backwards!!
class_name Enemy
extends CharacterBody2D

@export var Erunspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.
@export var Ewspeed: int = 50
@export var EDmgArea: Area2D #We will store our EDmgArea here. (it's an Area2D)
@export var base_damage : int = 1
static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

const NMYMAX_HEALTH = 10 #We make a new constant that defines the enemy has health.
var health = NMYMAX_HEALTH #We make a new variable based on the Health-constant.
var playerChr #We make a new variable to represent the player
var player_chase : bool = false #Represents the enemy chasing the player or not.
var is_roaming : bool = true #Represents the enemy randomly walking around.
var targets : Array[Node2D]
var atk_raycast : RayCast2D
var edge_rayL : RayCast2D #Left edge-raycast, to detect where a cliff is.
var edge_rayR : RayCast2D #Right edge-raycast, to detect where a cliff is.
var dead : bool = false #Determines if the enemy is dead or not.
var before_1st_atk : Timer #This variable is the time between spotting the player and attacking.
var direction_timer: Timer #A variable storing the time before the enemy changes direction when idling.
var move_dir : Vector2 :
	set(new_dir):
		move_dir = new_dir
var last_direction = 1 #Value that show the direction the player was moving in, last.
var current_direction = 1 #Check for the player's current moving direction.
var EFlip : Marker2D
var backoff_time: Timer


func _ready() -> void:
	before_1st_atk = $ETimer #We define a timer to delay our 1st attack.
	direction_timer = $DirTimer
	playerChr = get_tree().get_first_node_in_group("playerGroup")
	print_debug("Got the player from Tree.")
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	EDmgArea.body_entered.connect(_on_pbody_ent_dmg) #Connecting Give-Damage-area.
	atk_raycast = $FlipEk/EkAtkRC #We give the raycast-object (from the node-tree) to our nmy-raycast variable.
	edge_rayL = $FlipEk/EkEdgeL #Give the variable the left edge ray-cast
	edge_rayR = $FlipEk/EkEdgeR #Give the variable the Right edge ray-cast
	EFlip = $FlipEk
	backoff_time = $EbackTimer
	
func _physics_process(delta: float) -> void:
	_apply_gravity(delta) # Add the gravity.
	_roaming(delta) 
	_rush_player(delta) #Run towards the player. (we check if we should run the function)
	move_and_slide()

#Is the issue that DIRECTION isn't defined ever??
func _roaming(_delta):
	#If we're not dead, not chasing the player, and standing on the floor, then...
	if dead == false and self.is_on_floor() and player_chase == false and is_roaming ==  true:
		velocity = move_dir * Ewspeed 
		is_roaming = true
		print_debug("Enemy direction:", move_dir)
	elif dead == true:
		velocity.x = 0

func _on_dir_timer_timeout() -> void:
	direction_timer.wait_time = [1.3,1.8,2.3].pick_random() #We change the timers wait-time to a random value.
	direction_timer.start()
	if player_chase == false: #If we're not chasing the player then...
		move_dir = [Vector2.RIGHT, Vector2.LEFT].pick_random() #Choose a random left or right direction.
		_flip() #We run the function to see if we now need to flip the player.
		print_debug("New random direction?")
		
#Code to flip the character when walking.
func _flip():
	#Guard clause
	if move_dir.x == 0:
		return
	#END Guard clause
	if edge_rayL.is_colliding() and edge_rayR.is_colliding(): #If BOTH edge-detects are colliding, then...
		#We do the regular flipping.
		var signed_x : float = sign(move_dir.x) #A variable that stores if the direction is positive or negative.
		EFlip.scale.x = abs(scale.x) *  signed_x #We flip the scale of our Flip-marker based on our signedx-direction variable.
		current_direction = signed_x
		#Update the last direction variable.
		last_direction = current_direction
	
	if !edge_rayL.is_colliding() or !edge_rayR.is_colliding(): #But if one of our edge-detects are not detecting...
		current_direction = !current_direction #...then we invert our direction.
		print_debug("Changed direction:", move_dir)
	
	
func _rush_player(_delta : float):
	#Guardclause, to prevent attacking without player.
	if playerChr == null or GameManager.instance.is_game_over == true: #But if there is no player and game is over, then...
		print_debug("Player is dead, Enemy won't attack.")
		return #...We don't do anything.
	if !before_1st_atk.is_stopped():
		return
	#END guard-clause
	
	#Raycasting, for detecting the player.
	if atk_raycast.is_colliding(): #If the raycast hits the player...
		is_roaming = false #We make sure we're not roaming.
		before_1st_atk.start() #...we start a timer to delay the 1st attack.
		await before_1st_atk.timeout #...which delays the below attack-code.
		#If the enemy is touching the floor and we're not in Game Over, then...
		if self.is_on_floor() and GameManager.instance.is_game_over == false : 
			move_dir = (playerChr.position - self.position).normalized()
			velocity.x = move_dir.x * Erunspeed
			player_chase = true #We say that we're chasing the player.
			#print("Detected player")
			return
	else:
		return
		
func _apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity() #We make a new temp-var, and base it on the get-gravity-function.
		velocity.y += gravity.y * delta
	else: #Otherwise, we...
		return #...don't do anything. (no gravity-application)
	
func take_damage(damage : int):
	health -= damage #Enemy's health decreases by 5, per punch that connects.
	print("Enemy Took Damage!")
	if health <= 0: #If the enemy is out of health, he dies.
		dead = true #We set the dead-bool to true.
		print("Something killed the Cube-enemy!")
		queue_free() #We free the enemy from memory... we destroy it.
		

#Giving damage to player.
func _on_pbody_ent_dmg(node : Node2D) -> void:
	if node is Player:
		node.take_damage(base_damage)
		backoff_time.start()
		print_debug("running backoff-timer")
		while !backoff_time.is_stopped():
			#Make the enemy back off after damaging the player.
			self.velocity.x = Ewspeed #Enemy moves backwards at walk-speed.
			print_debug("Enemy back-speed:", velocity)
		
	
func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
