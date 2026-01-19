extends Node2D

@export var Nmyspeed: int = 200 #We make a new variable: Enemy Speed, which is an Int with 200 as standard value.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	self.position.y += Nmyspeed * delta #Makes the enemy go downwards.
	
	
func _on_area_entered(_area: Area2D) -> void: #When something enters the Area2D, aka collider, then...
	print("Something collided with enemy!")
	#Pesudo-code: is touching other area -> destroy self
	self.queue_free() #We free the enemy from memory... we destroy it.
	
	#Increase score when enemy dies.
	GameState.score += 10
	
