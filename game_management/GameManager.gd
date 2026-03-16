class_name GameManager
extends Node
#This is our Singleton that remembers our score and other things, in-between scenes.
#The GAME MANAGER, essentially.

signal level_entered #A signal to show that the Player has entered a level.
var save_game : SaveGame
@export var level_2D : Node2D #We set up a variable for the levels.
@export var gui : Control #A variable for the various Graphical User Interface.

var current_level2d : Node2D
var current_level_name : String :
	get():
		return level_dict.find_key(current_level2d)
var current_gui : Control
var level_dict : Dictionary[String, Node2D] = {}
var gui_dict : Dictionary[String, Control] = {} #Store loaded scenes by path. We make a dictionary for our scenes, so we don't overload memory.
var is_game_over : bool = false #Boolean that controls if the game is over or not.
#var score: int = 0 #We have a variable for score, which of course starts at zero.
static var instance : GameManager

func _init() -> void:
	instance = self

func _ready() -> void:
	await get_tree().process_frame
	save_game = SaveManager.instance.save_game
	current_gui = null
	current_level2d = level_2D 
	
	#When you start, the current Level2D should just be the preset one.
	#We define entries in the Gui and Level -dictionaries.
	gui_dict["PauseMenu"] = %PauseMenu
	
	#DEFAULTS TO RUNTIME DICT
	level_dict["Level1"] = %LevelTest1
	level_dict["Level2"] = %LevelTest2
	
	#OVERRIDE RUNTIME DICT
	override_runtime_from_save()
	
	#SAVE NEW DEFAULTS TO SAVE GAME
	for level_name in level_dict.keys():
		if !save_game.level_data_dict.has(level_name):
			var level : Node2D = level_dict[level_name]
			var level_pack : PackedScene = LevelPacker.create_package(level)
			save_game.level_data_dict[level_name] = level_pack
	if save_game.clean_save == false:
		load_level2D(save_game, false)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_game_over_check(delta)

func _game_over_check(_delta) -> void:
	if is_game_over == true and Input.is_action_just_pressed("ui_accept") :
		print_debug("enter has been pressed")
		#Reload the scene.
		get_tree().reload_current_scene() #We get the whole tree, everything in every scene & then we reload the current scene, aka level.
		reset_values() #And reset the values too.

func override_runtime_from_save():
	for level_data_name in save_game.level_data_dict.keys():
		var pack : PackedScene = save_game.level_data_dict[level_data_name]
		var level_instance : Node2D = pack.instantiate()
		if level_dict.has(level_data_name):
			var default_level : Node2D = level_dict[level_data_name]
			if current_level2d == default_level: #REWRITE IF MAIN SCENE EVER LACKS DEFAULT LEVELS
				current_level2d = level_instance
				save_game.current_level = level_data_name
			default_level.queue_free()
			
		level_dict[level_data_name] = level_instance
		level_instance.hide()
		level_instance.process_mode = Node.PROCESS_MODE_DISABLED
		owner.add_child(level_instance)
	
	
	current_level2d.show()
	current_level2d.process_mode = Node.PROCESS_MODE_INHERIT
			
func change_level2D(new_level : String,
	entry_point : int,
	transition: bool = true,
	seconds: float = 0.8) -> void:
	
	#Condition to run a scene-transition.
	if transition == true:
		print_debug("We shall run a transition")
		TransitionController.instance.transition_out(seconds) #Get the instance of the controller & run the transition_out function.
		await TransitionController.instance.animation_player.animation_finished #Wait until the animation is done.
	#End transition-condition.
	#OLD LEVEL TURN OFF
	current_level2d.visible = false
	current_level2d.process_mode = Node.PROCESS_MODE_DISABLED
	current_level2d = level_dict[new_level] #Rewrite here
	
	#NEW LEVEL TURN ON
	current_level2d.place_player(Player.instance, entry_point) #We run the place-player function from the Level-script, using the string that references an Entry-point.
	await get_tree().process_frame
	current_level2d.visible = true
	current_level2d.process_mode = Node.PROCESS_MODE_INHERIT
	
	if transition == true:
		TransitionController.instance.transition_in(seconds) #Now we run the fade in transition as well.
	
func load_level2D(
	_save_game : SaveGame,
	transition: bool = true,
	seconds: float = 0.8
	) -> void:
	
	save_game = _save_game
	override_runtime_from_save()
	#save_game = LevelPackUser.instance.created_package #We turn our save into the level-pack.
	#Condition to run a scene-transition
	if transition == true:
		print_debug("We shall run a transition")
		TransitionController.instance.transition_out(seconds) #Get the instance of the controller & run the transition_out function.
		await TransitionController.instance.animation_player.animation_finished #Wait until the animation is done.
	#End transition-condition.
	#OLD LEVEL TURN OFF
	current_level2d.visible = false
	current_level2d.process_mode = Node.PROCESS_MODE_DISABLED
	current_level2d = level_dict[save_game.current_level]
	
	#NEW LEVEL TURN ON
	#current_level2d.place_player(Player.instance, entry_point) #We run the place-player function from the Level-script, using the string that references an Entry-point.
	var player : Player = Player.instance
	player.global_position = save_game.player_glob_pos
	if !save_game.is_facing_right:
		player.flip()
	await get_tree().process_frame
	current_level2d.visible = true
	current_level2d.process_mode = Node.PROCESS_MODE_INHERIT
	
	if transition == true:
		TransitionController.instance.transition_in(seconds) 

#Below is the OLD load-function.
#func load_level2D(save_game : SaveGame = SaveGame.new(),
	#transition: bool = true,
	#seconds: float = 0.8) -> void:
	#
	##Condition to run a scene-transition.
	#if transition == true:
		#print_debug("We shall run a transition")
		#TransitionController.instance.transition_out(seconds) #Get the instance of the controller & run the transition_out function.
		#await TransitionController.instance.animation_player.animation_finished #Wait until the animation is done.
	##End transition-condition.
	##OLD LEVEL TURN OFF
	#current_level2d.visible = false
	#current_level2d.process_mode = Node.PROCESS_MODE_DISABLED
	#current_level2d = level_dict[save_game.current_level]
	#
	##NEW LEVEL TURN ON
	##current_level2d.place_player(Player.instance, entry_point) #We run the place-player function from the Level-script, using the string that references an Entry-point.
	#var player : Player = Player.instance
	#player.global_position = save_game.player_glob_pos
	#if !save_game.is_facing_right:
		#player.flip()
	#await get_tree().process_frame
	#current_level2d.visible = true
	#current_level2d.process_mode = Node.PROCESS_MODE_INHERIT
	#
	#if transition == true:
		#TransitionController.instance.transition_in(seconds) #Now we run the fade in transition as well.
	
	
#This function manages GUI-scenes/prefabs
func change_gui_scene(
	#Local variables (WHY do I need to make these local?? seems like extra text.)
	new_guiscene: String,
	delete: bool,
	keep_running: bool,
	transition: bool,
	seconds: float = 0.8 ) -> void:
	
	#Condition to run a gui scene-transition.
	if transition == true:
		print_debug("We shall run a transition")
		TransitionController.instance.transition_out(seconds) #Get the instance of the controller & run the transition_out function.
		await TransitionController.instance.animation_player.animation_finished #Wait until the animation is done.
	elif transition == false:
		pass
	#End transition-condition.
	
	#Conditions to change GUI.
	if current_gui != null: #If we've currently got a GUI...
		if delete:
			current_gui.queue_free() #Remove from memory.
			gui_dict.erase(gui_dict.find_key(current_gui)) #remove it from dictionary.
		elif keep_running:
			current_gui.visible = false #Keeps the gui in memory and running.
			current_gui.process_mode = Node.PROCESS_MODE_DISABLED

	var new_gui: Control
	if gui_dict.has(new_guiscene):
		new_gui = gui_dict[new_guiscene]
		new_gui.visible = true
		new_gui.process_mode = Node.PROCESS_MODE_INHERIT
		
	if transition == true:
		TransitionController.instance.transition_in(seconds) #Now we run the fade in transition as well.

func reset_values(): #Because you died, but you're restarting...
	#score = 0
	is_game_over = false
	print_debug("Restarting game.")
