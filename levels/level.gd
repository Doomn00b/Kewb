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
	
func place_player(player, entry_point : int):
	player.global_position = entry_dict[entry_point].global_position
