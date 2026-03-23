class_name MainMenu
extends Control


func _on_new_game_pressed() -> void:
	GameManager.instance.new_game() #We get the GM instance and run its new-game function.
	print_debug("Started a new game.")

func _on_continue_pressed() -> void:
	var gm : GameManager = GameManager.instance
	gm.load_level2D(gm.save_game, true)
	#Run the load_level2D function from GameManager, to load a previous savegame.
	print_debug("Pressed Continue, aka Load game.") 
	# Replace with load_level2d from GameManager

func _on_settings_pressed() -> void:
	print_debug("Pressed settings, but we don't have any settings. Heh.") 
	# Replace with function body.


func _on_quit_pressed() -> void:
	#Put in something to make a box pop up that double-checks if you want to quit.
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) #Tell the rest of Godot that we want to close the game.
	get_tree().quit() #Close the game.
