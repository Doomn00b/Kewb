extends Node2D

@export var Nmyspeed: int = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	self.position.y += Nmyspeed * delta
