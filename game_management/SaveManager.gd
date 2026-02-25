#We save stuff in JSON-format, so it's human-readable.
#TODO: FIX PLAYER LOCATION / SPAWN-POINT!

@icon("res://game_management/save_symbol.png")
class_name SaveManager
extends Node
#Below, we make a Constant of Save-slots.
const SLOTS: Array[ String ] = [
	"save_01", "save_02", "save_03"]

var current_slot : int = 0 #The game we're currently playing.
var save_data: Dictionary 
var discovered_areas: Array = [] #Areas we've discovered on our map.
var persistent_data: Dictionary = {} #Upgrades, opened / unlocked doors, defeated boss's, discovered Secret.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func create_new_game_save() -> void:
	var new_game_level: String = "res://levels/KewbTest1.tscn"#Change this to the real level1 later.
	save_data = { #Key/Value in a dictionary - Key is the identifier for a value.
		"level_path" : new_game_level,
		#"player_location" : Level.instance.place_player(entry_point)
		"x" : 60, #TEMPORARY - just to get through tutorial- CHANGE later.
		"y" : 230,
		"hp" : 10,
		"max_health" : 10
	}	
	
func save_game() -> void:
	pass
	
func load_game() -> void:
	pass	
	
