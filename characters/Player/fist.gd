extends Area2D

@export var speed : int = 200 #We create a new variable to define the speed. Pixels per second. It's visible in the editor.
@export var damage : int = 5

func _on_body_entered(_enemy : Node2D) -> void:
	print("Punched an enemy!") # Message to make sure the fist-collision happens.
	if _enemy is Enemy:
		_enemy.take_damage(damage)
