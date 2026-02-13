class_name EnemyKewb
extends CharacterBody2D

@export var max_speed : int = 40
@export var acceleration : int = 50
#Below is State-Machine
@onready var fin_sm = $FiniteStateMachine 
@onready var roaming_state = $FiniteStateMachine/EkRoamingState as EkRoamingState
@onready var rush_state = $FiniteStateMachine/EkRushState as EkRushState
#End state-machine access.

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

var playerChr #We make a new variable to represent the player
var move_dir : Vector2 :
	set(new_dir):
		move_dir = new_dir
var velocity_x: Vector2 #This variable is for only changing velocity on the X-axis, instead of both axis.

var flip: Marker2D
var animator: AnimationPlayer

var atk_raycast : RayCast2D
var edge_rayL : RayCast2D #Left edge-raycast, to detect where a cliff is.
var edge_rayR : RayCast2D #Right edge-raycast, to detect where a cliff is.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity_x = Vector2(-velocity.x, velocity.y) #We "preserve" y, aka remove it from the velocity, so we can use it for flipping.
	enemies_spawned += 1 #When we start the scene, enemy-count will go up.
	playerChr = get_tree().get_first_node_in_group("playerGroup")
	flip = $FlipEk
	atk_raycast = $FlipEk/EkAtkRC
	edge_rayL = $FlipEk/EkEdgeL
	edge_rayR = $FlipEk/EkEdgeR
	animator = $AnimationPlayer
	
	#State-Machine activation.
	roaming_state.found_player.connect(fin_sm.change_state.bind(rush_state)) #We connect the found player signal to activate the rush state
	rush_state.lost_player.connect(fin_sm.change_state.bind(roaming_state)) #Connecting lost player signal to activating roam state.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func _apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity() #We make a new temp-var, and base it on the get-gravity-function.
		velocity.y += gravity.y * delta
	else: #Otherwise, we...
		return #...don't do anything. (no gravity-application)
	
func _flip():
	flip.scale.x = sign(velocity.x) #We make it so our flip's scale is dependent on if the enemy is moving on the x-axis.
	if flip.scale.x == 0 : #If we're not moving, then...
		flip.scale.x = 1 #...we flip the scale, aka reverse direction.
	if !edge_rayL.is_colliding() or !edge_rayR.is_colliding(): #If one of our edge-raycasts aren't detecting...
		flip.scale.x = -1 #...we flip the scale.

func _wall_collide(delta):
	var collision = self.move_and_collide(self.velocity_x * delta)
	if collision:
		var bounce_velocity = self.velocity_x.bounce(collision.get_normal())
		self.velocity = bounce_velocity


func setup_enemy(pos : Vector2 = Vector2.ZERO): #A function that readies the enemy's properties in a level.
	self.global_position = pos #Sets up the position of the enemy.
	#Add setting health?
	#Add setting type of enemy??
