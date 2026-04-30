class_name EnemySpawner
extends Node2D

@export var enemy_tscn : PackedScene #We make sure that the editor knows the enemy-scene is a scene/prefab, and it's visible.
@export var spawn_points : Array[Marker2D]

@export var unit_test : bool = false

func _ready() -> void:
	#Add some stuff here, to make sure spawning happens?
	#If game loaded, run spawn enemies anyway??
	#region Testing-functions
	if unit_test == true:
		spawn_enemies()
	#endregion
		
	elif !GameManager.instance.new_game_made and GameManager.instance.game_loaded: #If we haven't made a new game and we loaded a game
		spawn_enemies() #...we run spawn enemies to make sure.
	#elif OS.has_feature("editor") and unit_test == true:
		#spawn_enemies()

#Pseudo-code: Spawn new enemy every 1 second.
func spawn_enemies(): #Our custom-function to spawn enemies.
	for point in spawn_points: #For each spawn-point we have, we will spawn an enemy.
		var new_enemy = enemy_tscn.instantiate() #We make a new variable out of the enemy-scene/prefab.
		
		#We make a new var that decides where the enemy can spawn.
		new_enemy.setup_enemy(point.global_position) #Add position for setup, based on position of spawn-point.
		
		print_debug("Enemy spawned!")
		
		add_sibling.call_deferred(new_enemy) #We make the new, placed enemy, a new child of the Level-node. (but not out of the spawner-node)
	
