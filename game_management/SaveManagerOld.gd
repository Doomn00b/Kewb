#Based on this tutorial: https://www.youtube.com/watch?v=fKM-zXWtnc4&list=PLfcCiyd_V9GFL_xF8ID9vIt5bs0NJI4EK&index=29
#We save stuff in JSON-format, so it's human-readable.
#TODO: FIX PLAYER LOCATION / SPAWN-POINT!
		#Add player upgrades set to false.
		
@icon("res://game_management/save_symbol.png")
class_name SaveManagerOld
extends Node
#Below, we make a Constant of Save-slots.
const SLOTS: Array[ String ] = [
	"save_01", "save_02", "save_03"]

var current_slot : int = 0 #The game we're currently playing.
var save_data: Dictionary 
var discovered_areas: Array = [] #Areas we've discovered on our map.
var persistent_data: Dictionary = {} #Upgrades, opened / unlocked doors, defeated boss's, discovered Secret.
#Dictionairies have built-in functions like get_or_add()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func create_new_game_save() -> void:
	var new_game_level: String = "res://levels/KewbTest1.tscn"#Change this to the real level1 later.
	discovered_areas.append( new_game_level )
	save_data = { #Key/Value in a dictionary - Key is the identifier for a value.
		"level_path" : new_game_level,
		#"player_location" : Level.instance.place_player(entry_point)
		"x" : 60, #TEMPORARY - just to get through tutorial- CHANGE later.
		"y" : 230,
		"hp" : 10,
		"max_health" : 10,
		#We'll add the upgrades later
		#"power_punch": false,
		"discovered_areas": discovered_areas,
		"persistent_data": persistent_data,
	}
	#Save game data
	var save_file = FileAccess.open("user://save.sav", FileAccess.WRITE) #Create a variable that saves in the OS's user-directory.
	save_file.store_line( JSON.stringify(save_data)) #Turn all of the entries in save_data into jason-text.
	
func save_game() -> void:
		save_data = { #Key/Value in a dictionary - Key is the identifier for a value.
		"level_path" : GameManager.instance.current_level2d,
		#"player_location" : Level.instance.place_player(entry_point)
		"x" : 60, #TEMPORARY - just to get through tutorial- CHANGE later.
		"y" : 230,
		"hp" : 10,
		"max_health" : 10,
		#We'll add the upgrades later
		#"power_punch": false,
		"discovered_areas": discovered_areas,
		"persistent_data": persistent_data,
		}
	
func load_game() -> void:
	var _load_file = FileAccess.open("user://save.sav",FileAccess.READ)
	
#Function for testing the saving and loading, with keyboard shortcuts, instead of UI and checkpoints.
func _unhandled_input(_event: InputEvent) -> void:
	#F5
	if Input.is_action_just_pressed("save_test"):
		create_new_game_save()
	#ctrl-F9
	if Input.is_action_just_pressed("load_test"):
		load_game()
