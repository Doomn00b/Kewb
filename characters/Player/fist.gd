extends Area2D

@export var speed : int = 200 #We create a new variable to define the speed. Pixels per second. It's visible in the editor.
@export var damage : int = 5

	#The position of the laser on the y-axis is based on our speed-variable.
	#self.position.x += speed * _delta #We make the position change independent of the frame-rate.

#Pseudo-code: touches Enemy, destroys self and enemy.


func _on_body_entered(_enemy : Node2D) -> void:
	print("Punched an enemy!") # Message to make sure the fist-collision happens.
	if _enemy is Enemy:
		_enemy.take_damage(damage)
	#If it hit an enemy.
	
	#if _enemyArea.is_in_group("enemyGroup"): #If the object is tagged with _enemyArea and is a part of the tag-group enemyGroup, then...
		#self.queue_free() #We remove the laser from memory, we destroy it.
