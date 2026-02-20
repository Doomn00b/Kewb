class_name GameManager
extends Node

#This is our Singleton that remembers our score and other things, in-between scenes.
#The GAME MANAGER, essentially.

@export var level_2D : Node2D #We set up a variable for the levels.
@export var gui : Control #A variable for the various Graphical User Interface.

var current_level2d : Node2D
var current_gui : Control
var scene_cache: Dictionary = {} #Store loaded scenes by path. We make a dictionary for our scenes, so we don't overload memory.
var is_game_over : bool = false #Boolean that controls if the game is over or not.
#var score: int = 0 #We have a variable for score, which of course starts at zero.
static var instance : GameManager

func _init() -> void:
	if instance != null: #First we check if the gamemanager-instance is already set...
		if instance != self: #...then if the gamemanager instance isn't self, aka the current instance...
			instance = self #...then set instance to self.
		else: #...but if it's already set to self, then...
			pass #...move on with the script.
	else: #But if it's set to begin with...
		print_debug("GameManager already set, moving on.")
		pass #Move on with the rest of the script.

func _ready() -> void:
	current_gui = SplashScreenManager.instance
	current_level2d = level_2D
	
	if current_gui and current_gui.scene_file_path: #If there's a current gui and it has a filepath, then...
		scene_cache[current_gui.scene_file_path] = current_gui #...look into the scene-cache using the filepath and make that the current gui.
	
	if current_level2d and current_level2d.scene_file_path:
		scene_cache[current_level2d.scene_file_path] = current_level2d
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and is_game_over == true:
		print_debug("enter has been pressed")
		#Reload the scene.
		get_tree().reload_current_scene() #We get the whole tree, everything in every scene & then we reload the current scene, aka level.
		reset_values() #And reset the values too.

func change_level2D(
	#function variables
	new_lvlscene: String, 
	delete: bool = true, 
	keep_running: bool = false, 
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 0.8) -> void:
		
	#Condition to run a gui scene-transition.
	if transition:
		TransitionController.instance.transition(transition_out, seconds) #Get the instance of the controller & run the transition-function, with the fade_out animation as a variable.
		await TransitionController.instance.animation_player.animation_finished #Wait until the animation is done.
	#End transition-condition.
		
	if current_level2d != null: #If there's a current level running, then...
		if delete:
			var scene_path = current_level2d.scene_file_path
			current_level2d.queue_free() #Removes the level entirely.
			scene_cache.erase(scene_path) #remove it from dictionary.
		elif keep_running:
			current_level2d.visible = false #Keeps the level in memory and RUNNING, but invisible.
		else:
			level_2D.remove_child(current_level2d) #This keeps the Level in memory, but NOT running.	
	#var newL2D = load(new_lvlscene).instantiate() #Variable that defines a new Level based on a new instance of new_lvlscene.
	#level_2D.add_child(newL2D) #We make the new popup/gui a child of gui, so it appears under it in the editor.
	#current_level2d = newL2D
	var new_level: Control
	if scene_cache.has(new_lvlscene):
		new_level = scene_cache[new_lvlscene]
		if new_level.get_parent() == null:
			level_2D.add_child(new_level)
		#TransitionController.instance.transition(transition_in, seconds) #We do a transition BEFORE we make the level entirely visible.
		new_level.visible = true
	
	TransitionController.instance.transition(transition_in, seconds) #Now we run the fade in transition as well.
	
#This function manages GUI-scenes/prefabs
func change_gui_scene(
	#Local variables (WHY do I need to make these local?? seems like extra text.)
	new_guiscene: String,
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 0.8 ) -> void:
	
	#Condition to run a gui scene-transition.
	if transition:
		TransitionController.instance.transition(transition_out, seconds) #Get the instance of the controller & run the transition-function, with the fade_out animation as a variable.
		await TransitionController.instance.animation_player.animation_finished #Wait until the animation is done.
	#End transition-condition.
	
	#Conditions to change GUI.
	if current_gui != null: #If we've currently got a GUI...
		if delete:
			var scene_path = current_gui.scene_file_path #store the file path of the current gui in the dictionary in this variable.
			current_gui.queue_free() #Remove from memory.
			scene_cache.erase(scene_path) #remove it from dictionary.
		elif keep_running:
			current_gui.visible = false #Keeps the gui in memory and running.
		else:
			gui.remove_child(current_gui) #This keeps the GUI in memory, but NOT running.	
	
	var new_gui: Control
	if scene_cache.has(new_guiscene):
		new_gui = scene_cache[new_guiscene]
		if new_gui.get_parent() == null:
			gui.add_child(new_gui)
		new_gui.visible = true
	#Old code that could lead to issues, down below.
	#var newGUI = load(new_guiscene).instantiate() #Variable that defines a new GUI based on a new instance of new_guiscene.
	#gui.add_child(newGUI) #We make the new popup/gui a child of gui, so it appears under it in the editor.
	#current_gui = newGUI
	
	TransitionController.instance.transition(transition_in, seconds) #Now we run the fade in transition as well.

func reset_values(): #Because you died, but you're restarting...
	#score = 0
	is_game_over = false
	print_debug("Restarting game.")
