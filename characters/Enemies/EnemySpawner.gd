class_name EnemySpawner
extends Node2D

@export var enemy_tscn : PackedScene #We make sure that the editor knows the enemy-scene is a scene/prefab, and it's visible.
@export var spawn_points : Array[Marker2D]

#Pseudo-code: Spawn new enemy every 1 second.
func spawn_enemies(): #Our custom-function to spawn ships.
	for point in spawn_points:
		var new_enemy = enemy_tscn.instantiate() #We make a new variable out of the enemy-scene/prefab.
		
		#We make a new var that decides where the enemy can spawn.
		new_enemy.setup_enemy(point.global_position) #Add position for setup, based on position of spawn-point.
		
		print_debug("Enemy spawned!")
		
		add_sibling(new_enemy) #We make a new child of the main node. (but not out of the spawner-node)
	
