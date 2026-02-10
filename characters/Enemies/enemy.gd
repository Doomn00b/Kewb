#TODO: Make enemy move slowly idly. Make enemy flip direction.

class_name Enemy
extends CharacterBody2D

@export var Erunspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.
@export var Ewspeed: int = 80
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
var direction : Vector2

func _ready() -> void:
	before_1st_atk = $ETimer #We define a timer to delay our 1st attack.
	direction_timer = $DirTimer
	playerChr = get_tree().get_first_node_in_group("playerGroup")
	print_debug("Got the player from Tree.")
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	EDmgArea.body_entered.connect(_on_pbody_ent_dmg) #Connecting Give-Damage-area.
	atk_raycast = $FlipNmy/NmyAtkRC #We give the raycast-object (from the node-tree) to our nmy-raycast variable.
	edge_rayL = $FlipNmy/NmyEdgeL #Give the variable the left edge ray-cast
	edge_rayR = $FlipNmy/NmyEdgeR #Give the variable the Right edge ray-cast
	
func _physics_process(delta: float) -> void:
	_apply_gravity(delta) # Add the gravity.
	_roaming(delta) 
	_rush_player(delta) #Run towards the player. (we check if we should run the function)
	move_and_slide()

func _roaming(delta):
	#If we're not dead, not chasing the player, and standing on the floor, then...
	if dead == false and self.is_on_floor() and player_chase == false:
		velocity += direction * Ewspeed * delta
		is_roaming = true
	elif dead == true:
		velocity.x = 0

func _on_dir_timer_timeout() -> void:
	direction_timer.wait_time = choose([1.5,2.0,2.5])
	if player_chase == false:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
	
func choose(array): #This function is just for randomising things.
	array.shuffle() #Shuffle around the values in the array randomly.
	return array.front() #Take the current first value in the shuffled array.
	
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
		player_chase = true 
		before_1st_atk.start() #...we start a timer to delay the 1st attack.
		await before_1st_atk.timeout #...which delays the below attack-code.
		#If the enemy is touching the floor and we're not in Game Over, then...
		if self.is_on_floor() and GameManager.instance.is_game_over == false : 
			direction = (playerChr.position - self.position).normalized()
			velocity.x = direction.x * Erunspeed
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

func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
