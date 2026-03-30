class_name MainMenu
extends Control

#IDEA: count backwards one level in dictionary when pressing Escape, 
		#to go back to the previous menu.

@onready var main_menu : VBoxContainer = %MainMenu #We get the menu-boxes, so we can turn them on/off.
@onready var new_game_menu : VBoxContainer = %NewGameMenu
@onready var settings_menu : VBoxContainer = %SettingsMenu
@onready var controls_menu : VBoxContainer = %ControlsMenu

@onready var gm : GameManager = GameManager.instance
var menu_dict : Dictionary[String, VBoxContainer]
var current_menu : VBoxContainer
var previous_menu : VBoxContainer

func _ready() -> void:
	menu_dict["Main"] = main_menu
	menu_dict["NewGame"] = new_game_menu
	menu_dict["Settings"] = settings_menu
	menu_dict["Controls"] = controls_menu
	
	_hide_menus() #First we turn everything off...
	current_menu = main_menu #We make main menu the current menu we want.
	_show_menu() #And then we show main menu.

func _hide_menus():
	for unwanted_menu in menu_dict.values():
		unwanted_menu.hide()
		unwanted_menu.process_mode = Node.PROCESS_MODE_DISABLED

func _show_menu():
		current_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		current_menu.show()

#region Main Menu Buttons
func _on_new_game_pressed() -> void:
	_hide_menus() #Hide everything first.
	previous_menu = current_menu
	current_menu = new_game_menu
	_show_menu()

func _on_continue_pressed() -> void:
	_hide_menus()
	gm.load_level2D(gm.save_game, true)
	#Run the load_level2D function from GameManager, to load a previous savegame.
	print_debug("Pressed Continue, aka Load game.") 
	# Replace with load_level2d from GameManager

func _on_settings_pressed() -> void:
	_hide_menus()
	previous_menu = current_menu
	current_menu = settings_menu
	_show_menu()
	print_debug("Pressed settings.") 

func _on_quit_pressed() -> void:
	#Put in something to make a box pop up that double-checks if you want to quit.
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST) #Tell the rest of Godot that we want to close the game.
	get_tree().quit() #Close the game.
#endregion

#region New Game buttons 
#These buttons shows up when we go to the Create_game menu.
func _on_slot_1_pressed() -> void: 
	#TODO: Add some code here for making a new save game and stuff
	gm.instance.new_game() #We get the GM instance and run its new-game function.
	print_debug("Started a new game in slot1.")
	
func _on_slot_2_pressed() -> void:
	#Make the Main Menu invisible.
	pass # Replace with function body.
	
func _on_slot_3_pressed() -> void:
	#Make the Main Menu invisible.
	pass # Replace with function body.
#endregion

func _on_controls_pressed() -> void:
	_hide_menus()
	previous_menu = current_menu
	current_menu = controls_menu
	_show_menu()
	print_debug("Pressed settings.") 


func _unhandled_input(event: InputEvent) -> void:
	#region Go back in menu Guard-clause!
	if self.process_mode == PROCESS_MODE_DISABLED:
		return
	#endregion
	elif event.is_action_pressed("ui_cancel"):
		if previous_menu == null:
			return
		#Audio-cue.
		_hide_menus() #First we turn everything off...
		current_menu = previous_menu
		_show_menu() #Then we show the menu we want to see.
		print_debug("Pressed Cancel, aka Escape.")
