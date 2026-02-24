extends Node2D


@export var entry_points : Array[Marker2D]
var player : Player

func _ready():
	player = Player.instance

func place_player(player : Player, target_area : int):
	player.global_position = entry_points[target_area].global_position
