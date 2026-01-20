extends Node2D

@export var laser_tscn: PackedScene #We make sure that the editor knows the laser-scene is a scene/prefab.

func _process(_delta):
	#print("This happens every moment of the game.")
	var mouse_pos = get_global_mouse_position() #We create a new variable based on the global mouse pos function.
	position.x = mouse_pos.x #We make the players x-position the same as the mouse x.position.
	
	
	# pseudocode - Player clicks -> spawn laser
	if Input.is_action_just_pressed("shoot"): #If the player presses the shoot-action, then...
		print("Laser fired!")
		var new_laser = laser_tscn.instantiate()
		add_sibling(new_laser) #We make a new child of the main node, instead of the lasers becoming children of the player.
		new_laser.position = self.position #We make the laser-children spawn at the player-ship.


func _on_area_entered(_enemyArea: Area2D) -> void: #If something tagged _enemyArea enters the plater-ships collider, then..
	if _enemyArea.is_in_group("enemyGroup"):
		self.queue_free() #...destroy the Player by removing from memory.
		
		GameState.is_game_over = true
