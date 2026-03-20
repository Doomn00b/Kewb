class_name SaveGame
extends Resource
#@export var best_score := 0 #If you have a best score...
#@export var scores_history := [] #Array that holds our score-history.

#@export var pp_upgrade: Resource = null #The power-punch upgrade

@export var player_glob_pos := Vector2(0,0) #This will use the players global position from spawn-points.
@export var current_level := ""
@export var is_facing_right : bool #Whether the player will face left or right, when loaded.
@export var player_health : int = 10
@export var level_data_dict : Dictionary[String, PackedScene] = {} #Example of how to do persistent level data
@export var clean_save : bool = true
#We need:
	#Global Position
	#Players current health. player/health
	#Upgrades
	#Direction the player was facing. player/current_direction
func reset_all_save():
	player_glob_pos = Vector2(0,0)
	current_level = ""
	is_facing_right = false
	player_health = 10
	level_data_dict = {}
	clean_save = true
