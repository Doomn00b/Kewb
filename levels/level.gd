class_name Level
extends Node2D

#@export var entry_points : Array[Node2D]
@export_category("Put Entry-points, Name & Marker, here")
@export var entry_dict : Dictionary[int, Node2D]
var player : Player
static var instance : Level

func _init() -> void:
	instance = self

func _ready():
	player = Player.instance
	
func place_player(_player, entry_point : int):
	player = _player
	GameManager.instance.show_player() #We make sure the player is active and visible.
	_player.global_position = entry_dict[entry_point].global_position #Changes the players position to the first entry-point.



#Pseudo-code:
#If the Player starts a new game, it just does the above. 
#But if the player LOADS/continues a game, it does not run the above code!
#Use a bool in the game-manager for this?
#
