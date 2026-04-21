#This class is just for sorting things that are inside of the game-world
@icon("res://game_management/world_symbol.png")
class_name World
extends Node

static var instance : World

func _init() -> void:
	instance = self

func disable_tiles(): #This function is run by the GameManager, to turn off all tiles in the levels
	for tiles in get_tree().get_nodes_in_group("Tiles"):
		tiles.collision_enabled = false
		print_debug("Turned off Tiles in World.")
	
