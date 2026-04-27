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

#ENABLING TILES.
#func enable_tiles(in_level : Node2D, tile_array : Array):
	#in_level = self.instance
	#get_tiles(in_level, tile_array)
	#activate_tiles(tile_array)
	#
#func get_tiles(in_level, tile_array := []):
	#tile_array.push_back(in_level)
	#for tiles in in_level.get_children(): 
		#if tiles.is_in_group("Tiles"):
			#tile_array = get_tiles(tiles, tile_array)
			#print_debug("Got a tileMapLayer.")
	#return tile_array
	#
#func activate_tiles(tile_array):
	##for _tileMapLayer in get_tiles(get_tree().get_root()):
	#for _tileMapLayer in tile_array:
		#if _tileMapLayer is TileMapLayer:
			#_tileMapLayer.collision_enabled = true
			#print_debug("Enabled a tileMapLayer.")
	#print_debug("Finished enabling tiles.")
	

#func enable_tileset():
##Filtering out the tilemaplayers...
	#var filt_tiles : Array = []
	#for child in self.instance.get_children(): 
		#if child.is_in_group("Tiles"): 
			#filt_tiles.append(child)
			#print_debug("Found a tile.")
	#await get_tree().process_frame
	#print_debug(filt_tiles)
	#for tiles in filt_tiles:
		#tiles.collision_enabled = true
		#print_debug("Enabled collission in tile.")
		##await get_tree().process_frame
		##filt_tiles.erase(tiles)
	#print_debug("Finished enabling tiles.")
	##filt_tiles.erase(filt_tiles)




#Pseudo-code:
#If the Player starts a new game, it just does the above. 
#But if the player LOADS/continues a game, it does not run the above code!
#Use a bool in the game-manager for this?
#
