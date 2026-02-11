#This is the enemy-Kewb's roaming state.
class_name EkRoamingState
extends State #We inherit from our old abstract class, making what's in here a State.

@export var actor: EnemyKewb
@export var animator: AnimationPlayer
@export var Ewspeed: int = 50 #The walking, aka Roaming -speed.

@export var atk_raycast : RayCast2D
@export var edge_rayL : RayCast2D #Left edge-raycast, to detect where a cliff is.
@export var edge_rayR : RayCast2D #Right edge-raycast, to detect where a cliff is.


var is_roaming : bool = true #Represents the enemy randomly walking around.


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _enter_state() -> void:
	set_physics_process(true)
	animator.play("ek_walk")
	
func _exit_state() -> void:
	pass
