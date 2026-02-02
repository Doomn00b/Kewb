class_name GameManager
extends Node

#This is our Singleton that remembers our score and other things, in-between scenes.
#The GAME MANAGER, essentially.

@export var level_2D : Node2D #We set up a variable for the levels.
@export var gui : Control #A variable for the various Graphical User Interface.

var current_level2d
var current_gui

#var score: int = 0 #We have a variable for score, which of course starts at zero.
var is_game_over : bool = false #Boolean that controls if the game is over or not.


func _ready() -> void:
	Global.GM = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and GM.is_game_over:
		print_debug("enter has been pressed")
		#Reload the scene.
		get_tree().reload_current_scene() #We get the whole tree, everything in every scene.
		#And then we reload the current scene, aka level.
		reset_values() #And reset the values too.

func change_level2D(new_level: String, delete: bool = true, 
keep_running: bool = false ) -> void:
	if current_level2d != null:
		if delete:
			current_level2d.queue_free() #Removes a node entirely.
		elif keep_running:
			current_level2d.visible = false #Keeps the gui in memory and running... BAD!
		else:
			gui.remove_child(current_level2d) #This keeps the GUI in memory, but NOT running.	
	var newL2D = load(new_level).instantiate() #Variable that defines a new GUI based on a new instance of new_guiscene.
	gui.add_child(newL2D) #We make the new popup/gui a child of gui, so it appears under it in the editor.
	current_level2d = newL2D
	

#This function manages GUI-scenes/prefabs
func change_gui_scene(new_guiscene: String, delete: bool = true, 
keep_running: bool = false) -> void:
	if current_gui != null:
		if delete:
			current_gui.queue_free() #Removes a node entirely.
		elif keep_running:
			current_gui.visible = false #Keeps the gui in memory and running... BAD!
		else:
			gui.remove_child(current_gui) #This keeps the GUI in memory, but NOT running.	
	var newGUI = load(new_guiscene).instantiate() #Variable that defines a new GUI based on a new instance of new_guiscene.
	gui.add_child(newGUI) #We make the new popup/gui a child of gui, so it appears under it in the editor.
	current_gui = newGUI


func reset_values(): #Because you died, but you're restarting...
	#score = 0
	is_game_over = false
	print_debug("Turned off movement.")
