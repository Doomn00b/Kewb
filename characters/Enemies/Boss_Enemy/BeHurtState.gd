class_name BeHurtState
extends State
#Hurt can lead to Death-state, backing off, Charging

signal b_hurt_

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.

var damage : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sm : FiniteStateMachine = get_parent()
	#actor.enemy_died.connect(sm.change_state.bind("Death")) #We connect the enemy_died signal to activate the death state
	
 
func enter_state() -> void:
	actor.animator.play("b_hurt")
	#Decrease health
	actor.take_damage(damage)

func update_state(_delta : float) -> void:
	actor.apply_gravity(_delta)
	#If hurt more than health, emit enemy died?
	
func exit_state() -> void:
	print("Boss exit hurt-state.")
