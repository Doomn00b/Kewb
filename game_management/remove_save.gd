#This script is called to remove the save-data, so there isn't conflicting such data when loading new games.
@tool
extends Node

#const DATA_PATH : String = "res://data/"

#@export_enum("save1", "save2", "save3") var save_folder : String = "save1"
@export_tool_button("remove_save_game", "Callable") var rem_save_game = remove_save_game

#@onready var DATA_PATH: String = SaveManager.instance.SAVE_GAME_PATH #This is actually a CONST, based on the constant in Savemanager.

func remove_save_game(): #I don't believe this is relevant yet... Maybe never.
	var save_path : String = "user://savegame.tres"
	#var dir = DirAccess.open(save_path)
	#dir.remove(save_path)
	DirAccess.remove_absolute(save_path)
