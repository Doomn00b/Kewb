class_name Enemy
extends Node2D

@export var Nmyspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

const MAX_HEALTH = 10 #We make a new constant that defines the enemy has health.
var health = MAX_HEALTH #We make a new variable based on the Health-constant.

func _ready() -> void:
	enemies_spawned += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	self.position.y += Nmyspeed * delta #Makes the enemy go downwards.
	
	
func _on_area_entered(_area: Area2D) -> void: #When something enters the Area2D, aka collider, then...
	print("Something collided with enemy!")
	#Pesudo-code: is touching other area -> destroy self
	self.queue_free() #We free the enemy from memory... we destroy it.
	
	#Increase score when enemy dies.
	GameState.increase_score(10)
	
func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
