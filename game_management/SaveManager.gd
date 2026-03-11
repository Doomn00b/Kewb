@icon("res://game_management/save_symbol.png")
class_name SaveManager
extends Node

const SAVE_GAME_PATH:= "user://savegame.tres"
var save_game: SaveGame = null

@export var player_char: Player #THIS is an issue! My player is not based on a resource.
@export var upgrades: Resource
#@export var health
@export var level_name := ""
@export var player_glob_pos := Vector2.ZERO 

func _ready() -> void: #For some reason we have to create an empty save-file before we can start saving/loading...
	if ResourceLoader.exists(SAVE_GAME_PATH):
		save_game = ResourceLoader.load(SAVE_GAME_PATH)#, "", ResourceLoader.CACHE_MODE_IGNORE)
	else: #But if there is no save-file, we'll create a new one.
		save_game = SaveGame.new()

func write_save() -> void:
	save_game.player_glob_pos = player_char.global_position
	save_game.is_facing_right = player_char.facing_right
	save_game.current_level = GameManager.instance.current_level_name
	
	var error_code:= ResourceSaver.save(save_game, SAVE_GAME_PATH)
	if error_code != OK:
		push_error("Failed to save game: " + error_string(error_code))
	else:
		print_debug("Saved game.")

func load_save() -> void:
	#GameManager.instance.change_level2D("Level1", false)
	if ResourceLoader.exists(SAVE_GAME_PATH):
		print_debug("Resourceloader exists.")
		save_game = ResourceLoader.load(SAVE_GAME_PATH)#, "", ResourceLoader.CACHE_MODE_IGNORE)
		GameManager.instance.load_level2D(save_game, true)
		print_debug("Loaded game")
	else:
		print_debug("SHIT! Couldn't load!")

#Function for testing the saving and loading, with keyboard shortcuts, instead of UI and checkpoints.
func _unhandled_input(_event: InputEvent) -> void:
	#F5 for saving
	if Input.is_action_just_pressed("save_test"):
		write_save()
	#F9 for loading
	if Input.is_action_just_pressed("load_test"):
		load_save()
