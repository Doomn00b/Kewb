class_name MainMenu
extends CenterContainer


func _on_new_game_pressed() -> void:
	GameManager.instance.change_level2D()


func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	#Put in something to make a box pop up that double-checks if you want to quit.
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) #Tell the rest of Godot that we want to close the game.
	get_tree().quit() #Close the game.
