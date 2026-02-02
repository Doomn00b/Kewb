class_name Enemy
extends CharacterBody2D

@export var Nmyspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.
@export var NmyArea2D: Area2D #We rename Area2D to NmyArea2D.

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

const NMYMAX_HEALTH = 10 #We make a new constant that defines the enemy has health.
var health = NMYMAX_HEALTH #We make a new variable based on the Health-constant.

#We make a new variable to represent the player, by looking through the whole god-damn
#three and grabbing the nodes in the "playerGroup". (tagged player)
var playerChr
var targets : Array[Node2D]
func _ready() -> void:
	playerChr = get_tree().get_first_node_in_group("playerGroup")
	print_debug("Got the player from Tree.")
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	NmyArea2D.body_entered.connect(_on_cube_nmy_area_2d_body_entered) #Connecting area2D
	NmyArea2D.body_exited.connect(_on_cube_nmy_area_2d_body_exited)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	_apply_gravity(delta)
	#If the player has spawned in the scene, and is within line of sight of enemy,
	#the enemy will attempt to attack?
	if playerChr != null: #If there's a player-character...
		#print("There is a player.")
		#velocity.x = playerChr.position.x * Nmyspeed #Makes the enemy go towards player.
		#print("Moving towards player.")
		
		if is_on_floor(): #Put in a condition that says they can only move if they're touching ground?
			var direction = (playerChr.position - self.position).normalized()
			velocity.x = direction.x * Nmyspeed
			#print("Found the player haha")
	elif playerChr == null: #But if there is no player, then...
		return #...We don't do anything.
	move_and_slide()




func _apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity() #We make a new temp-var, and base it on the get-gravity-function.
		#velocity += gravity * delta
		velocity.y += gravity.y * delta
		#velocity.x += gravity.x * delta
		#print("Applying gravity for enemy.")
	
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
		#Pesudo-code: is touching player area AND player is punching -> lower enemy health.
	if node.is_in_group("playerGroup"):
		targets.append(node)
	
func _on_cube_nmy_area_2d_body_exited(node : Node2D) -> void:
		#Pesudo-code: is touching player area AND player is punching -> lower enemy health.
	if node.is_in_group("playerGroup"):
		targets.erase(node)
	
func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
