#TODO: Make enemy move slowly idly. Make enemy flip direction.
	# Restore ability to get hurt

class_name Enemy
extends CharacterBody2D

@export var Nmyspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.
@export var NmyDmgArea: Area2D #We will store our NmyDmgArea here. (it's an Area2D)
@export var NmyHurtArea: Area2D #This 

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

const NMYMAX_HEALTH = 10 #We make a new constant that defines the enemy has health.
var health = NMYMAX_HEALTH #We make a new variable based on the Health-constant.
var playerChr #We make a new variable to represent the player
var player_chase : bool = false #Represents the enemy chasing the player or not.
var targets : Array[Node2D]
var atk_raycast : RayCast2D
var edge_rayL : RayCast2D
var edge_rayR : RayCast2D

var before_1st_atk : Timer #This variable is the time between spotting the player and attacking.

func _ready() -> void:
	before_1st_atk = $NmyCTimer #We define a timer to delay our 1st attack.
	playerChr = get_tree().get_first_node_in_group("playerGroup")
	print_debug("Got the player from Tree.")
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	NmyDmgArea.body_entered.connect(_on_pbody_ent_dmg) #Connecting Give-Damage-area.
	NmyDmgArea.body_exited.connect(_on_pbody_exi_dmg)
	NmyHurtArea.body_entered.connect(_on_pfist_ent_hurt) #Connecting Get-Hurt-area
	NmyHurtArea.body_exited.connect(_on_pfist_exi_hurt)
	
	atk_raycast = $FlipNmy/NmyAtkRC #We give the raycast-object (from the node-tree) to our nmy-raycast variable.
		
	edge_rayL = $FlipNmy/NmyEdgeL #Give the variable the left edge ray-cast
	edge_rayR = $FlipNmy/NmyEdgeR #Give the variable the Right edge ray-cast
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	_apply_gravity(delta)
	_on_raydetect(atk_raycast)
	_on_notdetect(atk_raycast)
	_attack_player(delta)
	move_and_slide()


func _attack_player(delta : float):
	#Guardclause, to prevent attacking without player.
	if playerChr == null or GameManager.instance.is_game_over == true: #But if there is no player and game is over, then...
		print_debug("Player is dead, Enemy won't attack.")
		return #...We don't do anything.
	if !before_1st_atk.is_stopped():
		return
	#END guard-clause
	
	#Raycasting, for detecting the player.
	if atk_raycast.is_colliding(): #If the raycast hits the player...
		#var nmy_ray_query : Vector2 = atk_raycast.get_collision_point()
		before_1st_atk.start() #...we start a timer to delay the 1st attack.
		await before_1st_atk.timeout #...which delays the below attack-code.
		#If the enemy is touching the floor and we're not in Game Over, then...
		if self.is_on_floor() and GameManager.instance.is_game_over == false : 
			var direction = (playerChr.position - self.position).normalized()
			velocity.x = direction.x * Nmyspeed
			print("Detected player at:")#,nmy_ray_result.position)
			return
	else:
		velocity.x = 0.0 #Replace with Elif-statement: if not on floor and no ray-query, then 0.
		


func _apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity() #We make a new temp-var, and base it on the get-gravity-function.
		velocity.y += gravity.y * delta
	else: #Otherwise, we...
		#print("We didn't turn on gravity for Enemycube.")
		return #...don't do anything. (no gravity-application)

	
func _input(event: InputEvent) -> void:
	pass

#Detecting the player, to chase them.
func _on_raydetect(node : RayCast2D) -> void:
	if atk_raycast.is_colliding() != null:
		#Targetting the player
		if node.get_collision_mask_value(3): #If the body that entered the Area is in the Player-group...
			targets.append(node) #...then put it in the list of targets.
			player_chase = true #And make it clear we're chasing the player.
			#print_debug("Chasing target on mask #3")

func _on_notdetect(node : RayCast2D) -> void:
	if atk_raycast.is_colliding() == null:
		#UN-targetting the player
		if node.get_collision_mask_value(!3): #If the body that entered the Area is in the Player-group...
			targets.erase(node) #...then put it in the list of targets.
			player_chase = false #And make it clear we're chasing the player.
			print_debug("Lost target.")
#END Detecting the player.

func _on_pbody_ent_dmg(node : Node2D) -> void:
	#Giving damage to player.
	if node.is_in_group("playerGroup"): #If the body that entered the Area is in the Player-group...
		print_debug("We can damage player.")
	else:
		return

func _on_pbody_exi_dmg(node : Node2D) -> void:
		#Stop damaging player.
	if node.is_in_group("playerGroup"):
		print_debug("Can't hurt player any more.")
	else:
		return		
		
func _on_pfist_ent_hurt(node : Node2D) -> void:
	if node.is_in_group("playerDmgGroup"):
		_nmy_gethurt()
		print_debug("Enemy got hurt!")#
		
func _on_pfist_exi_hurt(node : Node2D) -> void:
	if node.is_in_group("playerDmgGroup"):
		pass #Write way to stop getting hurt by player.

#This is only supposed to run when the player is in range of hurting us.
func _nmy_gethurt():
	if Input.is_action_just_pressed("attack"): #If the player attacks...
		#AND it's the player-damage zone that hits us...
		health -= 5 #Enemy's health decreases by 5, per punch that connects.
		print("Got punched by the Player!")
		if health <= 0: #If the enemy is out of health, he dies.
			queue_free() #We free the enemy from memory... we destroy it.
			print("Something killed the Cube-enemy!")
			#Increase score when enemy dies.
			#GameState.increase_score(10)


func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
