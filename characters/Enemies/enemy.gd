class_name Enemy
extends Node2D

@export var Nmyspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.
@export var NmyArea2D: Area2D

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

const MAX_HEALTH = 10 #We make a new constant that defines the enemy has health.
var health = MAX_HEALTH #We make a new variable based on the Health-constant.

#We make a new variable to represent the player, by looking through the whole god-damn
#three and grabbing the nodes in the "playerGroup". (tagged player)

@onready var playerChr = get_tree().get_nodes_in_group("playerGroup")[0]

func _ready() -> void:
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	NmyArea2D.body_entered.connect(_on_area_entered) #Connecting area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#If the player has spawned in the scene, and is within line of sight of enemy,
	#the enemy will attempt to attack?
	if playerChr != null: #If there's a player-character...
		#self.position.x -= playerChr.position.x * Nmyspeed * delta #Makes the enemy go towards player.
		if self.RigidBody2D
			var direction = (playerChr.position - self.position).normalized()
			self.position.x += direction.x * Nmyspeed * delta
		
			print_debug("Found the player haha")
	
func _on_area_entered(_playerArea: Area2D) -> void: #When the player enters the Area2D, aka collider, then...
	#Pesudo-code: is touching player area AND player is punching -> lower enemy health.
	if _playerArea.is_in_group("playerGroup") and Input.is_action_just_pressed("attack"): 
		health -= 5 #Enemies health decreases by 5, per punch that connects.
		print_debug("Punched an enemy in the face!")
		
		if health == 0: #If the enemy is out of health, he dies.
			self.queue_free() #We free the enemy from memory... we destroy it.
			print_debug("Something killed the Cube-enemy!")
			#Increase score when enemy dies.
			GameState.increase_score(10)
	
func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
