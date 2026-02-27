#Based on this tutorial: https://www.youtube.com/watch?v=TGdQ57qCCF0
#And this: https://www.gdquest.com/library/save_game_godot4/#what-changed-in-godot-4
class_name SaveManager
extends Resource

const SAVE_GAME_PATH:= "user://savegame.tres"
var save_game: SaveGame = null

@export var player_char: Resource
@export var upgrades: Resource

@export var level_name := ""
@export var player_glob_pos := Vector2.ZERO 

func _ready() -> void:
	pass

func write_save() -> void:
	var error_code:= ResourceSaver.save(self, SAVE_GAME_PATH)
	if error_code != OK:
		push_error("Failed to save game: " + error_string(error_code))

func load_save() -> void:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		save_game = ResourceLoader.load(SAVE_GAME_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
		#print_debug("SHIT!")
	else:
		print_debug("SHIT!")

#Function for testing the saving and loading, with keyboard shortcuts, instead of UI and checkpoints.
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("save_test"):
		write_save()
	if Input.is_action_just_pressed("load_test"):
		load_save()
