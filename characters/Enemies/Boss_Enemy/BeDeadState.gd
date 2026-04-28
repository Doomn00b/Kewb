class_name BeDeadState
extends State

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func enter_state() -> void:
	actor.animator.play("b_dead")
	if actor.animator.is_playing(): #If the animation is still playing...
		return  #...we go back and wait for it to end.
	actor.queue_free() #...otherwise we remove Boss from memory, destroying it.

func update_state(_delta : float) -> void:
	pass

func exit_state() -> void:
	pass #There's no exiting death-state.
