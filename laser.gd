extends Node2D

@export var speed: int = 200 #We create a new variable to define the speed. Pixels per second. It's visible in the editor.

func _process(_delta):
	
	#The position of the laser on the y-axis is based on our speed-variable.
	self.position.y -= speed * _delta #We make the position change independent of the frame-rate.
