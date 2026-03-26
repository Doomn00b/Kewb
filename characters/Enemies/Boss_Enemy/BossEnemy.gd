class_name BossEnemy
extends Enemy

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

signal b_damaged_player()
@export var base_damage : int = 2
@onready var spot_p_shapecast : ShapeCast2D = %SpotPlaySC

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
