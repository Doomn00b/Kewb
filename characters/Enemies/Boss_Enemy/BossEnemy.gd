class_name BossEnemy
extends Enemy

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
const B_MAX_HEALTH = 16
signal b_damaged_player
@export var base_damage : int = 2
@onready var spot_p_shapecast : ShapeCast2D = %SpotPlaySC
@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var playerChr = get_tree().get_first_node_in_group("playerGroup")

var health = B_MAX_HEALTH #We make a new variable based on the Health-constant.

static var enemies_spawned : int = 0 #This variable determines how many enemies have spawned.

func _ready() -> void:
	pass

func setup_enemy(pos : Vector2 = Vector2.ZERO):
	self.global_position = pos #Sets up the position of the enemy.


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	#NEEDS: Movement, Gravity, hurt_player, health, Health-BAR?
	move_and_slide()

func apply_gravity(delta : float):
	if not is_on_floor() : #Do I need MORE in the condition?
		var gravity = get_gravity() #We make a new temp-var, and base it on the get-gravity-function.
		velocity.y += gravity.y * delta
	else: #Otherwise, we...
		return #...don't do anything. (no gravity-application)


func _on_pbody_ent_dmg(node: Node2D) -> void:
	if node is Player:
		node.take_damage(base_damage)
		b_damaged_player.emit()
		
func take_damage(damage : int):
	health -= damage #Boss's health decreases by 5, per punch that connects.
	print("Boss Took Damage!")
	if health <= 0: #If the enemy gets zero or less health,then...
		enemy_died.emit() #...we emit the enemy-died signal.
		print("Boss-Enemy died, start death-state.")
