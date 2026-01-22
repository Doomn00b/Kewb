extends Node
#This is our Singleton that remembers our score and other things, in-between scenes.

#var score: int = 0 #We have a variable for score, which of course starts at zero.
var is_game_over = false #Boolean that controls if the game is over or not.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and GameState.is_game_over:
		print_debug("enter has been pressed")
		#Reload the scene.
		get_tree().reload_current_scene() #We get the whole tree, everything in every scene.
		#And then we reload the current scene, aka level.
		reset_values() #And reset the values too.

func reset_values(): #Because you died, but you're restarting...
	#score = 0
	is_game_over = false
	print_debug("Turned off movement.")
