extends Label

func _process(_delta: float) -> void:
	#var my_integer: int = 10
	#my_integer = "hellO!"
	
	self.text = "Score: " + str(GameState.score)
