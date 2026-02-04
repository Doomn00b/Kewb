extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameManager.is_game_over == true: #If the game is over (player died), then...
		self.visible = true #...make the GameOverLabel (popup) visible.
	
	elif GameManager.is_game_over and Input.is_action_just_pressed("ui_accept"):
		self.visible = false
