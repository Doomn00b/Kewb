#TODO: Solve raycast position-access error. (because of dictionary)


class_name Enemy
extends CharacterBody2D

@export var Nmyspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.
@export var NmyArea2D: Area2D #We rename Area2D to NmyArea2D.

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

const NMYMAX_HEALTH = 10 #We make a new constant that defines the enemy has health.
var health = NMYMAX_HEALTH #We make a new variable based on the Health-constant.
var playerChr #We make a new variable to represent the player
var player_chase : bool = false #Represents the enemy chasing the player or not.
var targets : Array[Node2D]
var nmy_raycast : RayCast2D

func _ready() -> void:
	playerChr = get_tree().get_first_node_in_group("playerGroup")
	print_debug("Got the player from Tree.")
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	NmyArea2D.body_entered.connect(_on_cube_nmy_area_2d_body_entered) #Connecting area2D
	NmyArea2D.body_exited.connect(_on_cube_nmy_area_2d_body_exited)
	nmy_raycast = $RayCast2D #We give the raycast-object (from the node-tree) to our nmy-raycast variable.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	_apply_gravity(delta)
	attack_player(delta)
	move_and_slide()


func attack_player(delta : float):
	#Raycasting, for detecting the player.
	 #Variable that stores the question of the direction of the Ray in space.
	#var nmy_ray_result = nmy_raycast.intersect_ray(nmy_ray_query) #Variable that stores the result of where the ray intersected with something. (based on where query was made)
	#the result is also a dictionary.
	
	#if playerChr != null and nmy_ray_result != null : #If there's a player-character... and if it breaks the detection-cone.
	if playerChr == null: #But if there is no player, then...
		return #...We don't do anything.
		
	if nmy_raycast.is_colliding():
		var nmy_ray_query : Vector2 = nmy_raycast.get_collision_point()
		if self.is_on_floor(): #Put in a condition that says they can only move if they're touching ground?
			var direction = (playerChr.position - self.position).normalized()
			velocity.x = direction.x * Nmyspeed
			print("Detected player at:")#,nmy_ray_result.position)
			return
	velocity.x = 0.0
		


func _apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity() #We make a new temp-var, and base it on the get-gravity-function.
		velocity.y += gravity.y * delta

	else: #Otherwise, we...
		#print("We didn't turn on gravity for Enemycube.")
		return #...don't do anything. (no gravity-application)

	
func _input(event: InputEvent) -> void:
	if !targets.is_empty() and Input.is_action_just_pressed("attack"): 
		health -= 5 #Enemies health decreases by 5, per punch that connects.
		print("Got punched by the Player!")
		
		if health <= 0: #If the enemy is out of health, he dies.
			queue_free() #We free the enemy from memory... we destroy it.
			print("Something killed the Cube-enemy!")
			#Increase score when enemy dies.
			#GameState.increase_score(10)

func _on_cube_nmy_area_2d_body_entered(node : Node2D) -> void:
		#Targetting the player
	if node.is_in_group("playerGroup"): #If the body that entered the Area is in the Player-group...
		targets.append(node) #...then put it in the list of targets.
		player_chase = true #And make it clear we're chasing the player.
	
func _on_cube_nmy_area_2d_body_exited(node : Node2D) -> void:
		#Pesudo-code: is touching player area AND player is punching -> lower enemy health.
	if node.is_in_group("playerGroup"):
		targets.erase(node) 
		player_chase = false #Make sure the Enemy stops chasing the player.
	
func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
