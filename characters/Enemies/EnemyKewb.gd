class_name EnemyKewb
extends CharacterBody2D

signal enemy_died()

@export var max_speed : int = 40
@export var acceleration : int = 50
@export var base_damage : int = 1
#Below variables are created when the Ready-function is run.
@onready var fin_sm = %EkStateMachine #The moment we start we get the State-Machine
@onready var playerChr = get_tree().get_first_node_in_group("playerGroup")
@onready var flip_node : Marker2D = %FlipEk
@onready var atk_raycast : RayCast2D = %EkAtkRC
@onready var edge_rayL : RayCast2D = %EkEdgeL
@onready var edge_rayR : RayCast2D = %EkEdgeR
@onready var animator : AnimationPlayer = %AnimationPlayer

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

const EK_MAX_HEALTH = 10 #We make a new constant that defines the enemy has health.

var health = EK_MAX_HEALTH #We make a new variable based on the Health-constant.
var move_dir : Vector2 :
	set(new_dir):
		move_dir = new_dir
var velocity_x: Vector2 #This variable is for only changing velocity on the X-axis, instead of both axis.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity_x = Vector2(-velocity.x, velocity.y) #We "preserve" y, aka remove it from the velocity, so we can use it for flipping.
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	
	#WHAT triggers the Take-damage function?? Nothing at the moment...
func take_damage(damage : int):
	health -= damage #Enemy's health decreases by 5, per punch that connects.
	print("Enemy Took Damage!")
	if health <= 0: #If the enemy gets zero or less health,then...
		enemy_died.emit() #...we emit the enemy-died signal.
		print("Enemy died, start death-state.")
		
func apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity() #We make a new temp-var, and base it on the get-gravity-function.
		velocity.y += gravity.y * delta
	else: #Otherwise, we...
		return #...don't do anything. (no gravity-application)
	
func flip():
	flip_node.scale.x = sign(velocity.x) #We make it so our flip's scale is dependent on if the enemy is moving on the x-axis.
	if flip_node.scale.x == 0 : #If we're not moving, then...
		flip_node.scale.x = 1 #...we flip the scale, aka reverse direction.
	if !edge_rayL.is_colliding() or !edge_rayR.is_colliding(): #If one of our edge-raycasts aren't detecting...
		flip_node.scale.x = -1 #...we flip the scale.
	
func wall_collide(delta):
	var collision = self.move_and_collide(self.velocity_x * delta)
	if collision:
		var bounce_velocity = self.velocity_x.bounce(collision.get_normal())
		self.velocity = bounce_velocity
	
func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
