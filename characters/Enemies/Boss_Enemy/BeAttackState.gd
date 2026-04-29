class_name BeAttackState
extends State

signal b_attack_hit
signal b_attack_miss

@export_category("Put Actor, aka Boss-prefab here")
@export var actor: BossEnemy #We put our "Actor" here, in this case, our Boss-enemy-kewb.

#Bunch of RNG for what happens when the player is hit...
var rng = RandomNumberGenerator.new()
var boss_pos = ["one", "two", "three", "four"]
var b_likely_weights = PackedInt32Array([1, 1, 2])

var hit_player : bool = false

var sm : FiniteStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _player : Player = Player.instance
	sm = get_parent()
	b_attack_miss.connect(sm.change_state.bind("Aggroed")) #We connect the found player signal to activate the rush state
	#b_attack_hit.connect(sm.change_state.bind("Backing"))
	b_attack_hit.connect(sm.change_state.bind("Laughing"))
	
func enter_state() -> void:
	print_debug("Boss entered ATTACK!")
	actor.animator.play("b_attack") #We play the attack-animation.
	#Running the animation above, will automatically make it so the player-body
	#could enter the damage-area, and hence the _on_pbody_ent_dmg function can run. 

func _on_pbody_ent_dmg(p_body: Node2D) -> void:
	if p_body is Player:
		p_body.take_damage(actor.base_damage)
		hit_player = true
		b_attack_hit.emit() #This will  change the state to backing or laughing.

func update_state(_delta : float) -> void:
	#region guard-clause
	if actor.animator.is_playing(): #If the attack-animation is still playing...
		return #...restart this function.
	#endregion
	if hit_player == false:
		b_attack_miss.emit()

func exit_state() -> void:
	print_debug("Boss exited Attack.")
