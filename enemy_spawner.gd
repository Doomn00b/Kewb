extends Node2D

@export var enemy_tscn: PackedScene #We make sure that the editor knows the enemy-scene is a scene/prefab, and it's visible.

#Pseudo-code: Spawn new enemy every 1 second.
func spawn_enemy_ship(): #Our custom-function to spawn ships.
	var new_enemy = enemy_tscn.instantiate() #We make a new variable out of the enemy-scene/prefab.
	add_sibling(new_enemy) #We make a new child of the main node. (but not out of the spawner-node)
	
	#We get the viewport (camera, size of screen) & make a new variable based on it
	var viewport_width = get_viewport_rect().size.x 
	#We make a new var that decides where, in a range, the enemy ships can spawn.
	var rand_x = randi_range(10, viewport_width) 
	new_enemy.position.x = rand_x
	new_enemy.position.y = -50
	print_debug("Enemy ship spawned!")
