class_name Fist
extends Area2D

@export var speed : int = 200 #We create a new variable to define the speed. Pixels per second. It's visible in the editor.
@export var damage : int = 5

@onready var fist_anim: AnimationPlayer = %FistAnim
var player : Player

func _init() -> void:
	player = Player.instance
	
func _on_body_entered(_enemy : Node2D) -> void:
	print("Punched an enemy!") # Message to make sure the fist-collision happens.
	if _enemy is Enemy and !BossEnemy : #If what enters the fists collision (gets hit by), is an enemy of some sort, then...
		_enemy.take_damage(damage) #...it takes regular damage.
	elif _enemy is Enemy and player.power_punch:
		damage = 10 #We double the damage.
		print_debug("Enabled Double-damage!")
		_enemy.take_damage(damage)
