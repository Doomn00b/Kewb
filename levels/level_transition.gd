@tool #A tool-script runs while we're in the editor.
@icon("res://levels/level_transition_symbol.png")
class_name LevelTransition
extends Node2D
signal player_ent_zone #We set up a signal that's emitted when the player enters the transition-zone.

enum SIDE #Enums for the sides of the transition-zone.
{LEFT, 
RIGHT, 
TOP, 
BOTTOM} 

@export_range( 2, 12, 1, "or_greater") var size: int = 2 : #Size-range that the scene-transition can have.
	set(value):
		size = value
		apply_area_settings()
@export var location: SIDE = SIDE.LEFT: #Which side the of the Level-space the transition is located.
	set(value):
		location = value
		apply_area_settings()
@export_file("*.tscn") var target_level : String = "" #We make a new Var that stores the target, and the target can only be the tscn-filetype
@export var target_area_name: String = "LevelTransition" #The target spawn-area the transition-zone leads to.

@onready var area_2d: Area2D = %LtArea #When the script starts, we store the level-transitions area2D.

func _ready() -> void:
	#GUARD-CLAUSE
	if Engine.is_editor_hint(): #If we're still in the editor (instead of the game), then...
		print_debug("We're running in the editor; turning off scene-transitions.")
		return #...don't run the scene-transition-code.
	#END Guard-Clause
	player_ent_zone.connect(_transition_level) #When we start the scene we connect a signal to the transition-level function.

func _on_lt_area_body_entered(body: Node2D) -> void: #Check if the player enters area.
	if body.is_in_group("playerGroup"): #If it's the player in the zone...
		print_debug("The player has entered transition-zone")
		player_ent_zone.emit() #...the signal is emitted, which starts the transition-level function.

func _transition_level(): #Transition to a different level, runs when signal is emitted.
	get_tree().change_scene_to_file(target_level) #Go through the tree, and change to the scene 


func apply_area_settings(): #This function changes the size et c properties of the transition-zone.
	area_2d = get_node_or_null("")
	#GUARD-CLAUSE:
	if not area_2d:
		print_debug("There's no transition-zone for me to change!")
		return
	#END Guard-Clause
	if location == SIDE.LEFT or location == SIDE_RIGHT:
		area_2d.scale.y = size
		if location == SIDE.LEFT :
			area_2d.scale.x = -1
		else:
			area_2d.scale.x = 1
	else:
		area_2d.scale.x = size
		if location == SIDE.TOP :
			area_2d.scale.y = 1
		else:
			area_2d.scale.y = -1
