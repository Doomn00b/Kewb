#Based on this tutorial: https://www.youtube.com/watch?v=gOcmEDWhPbo
#And this tutorial: 
class_name SaveGame
extends Resource


#@export var player_name := "" #This is if you let the player rename the main character.
#@export var best_score := 0 #If you have a best score...
#@export var scores_history := [] #Array that holds our score-history.

#@export var pp_upgrade: Resource = null #The power-punch upgrade

@export var player_glob_pos := Vector2(0,0) #This will use the players global position from spawn-points.
@export var current_level_path := ""
@export var is_facing_right: bool #Whether the player will face left or right, when loaded.

#We need:
	#Global Position
	#Players current health. player/health
	#Upgrades
	#Direction the player was facing. player/current_direction
