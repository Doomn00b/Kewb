class_name PlayDeadState
extends State

@export_category("Put Actor, aka Player-prefab here")
@export var actor: NewPlayer #We put our "Actor" here, in this case, our Player-kewb.

# Called when the node enters the scene tree for the first time.
func _ready() -> void: #Start
	pass

func enter_state() -> void:
	print_debug("Player entered Death!")
	actor.animator.play("player_dead") #We play the walking-animation, using the Actors animator.
	if actor.animator.is_playing():
		return
	else:
		actor.lock_movement() #We lock the player, so it doesn't move around.
		actor.dead_time.start() #We start a timer that's supposed to let our DEATH-ANIMATION play.
		print_debug("running dead-timer")
		while !actor.dead_time.is_stopped(): #For as long as the back-off-timer is running...
			#Make the enemy back off after damaging the player.
			await get_tree().process_frame
		print_debug("Player died.")
		GameManager.instance.is_game_over = true
		GameManager.instance.change_gui_scene("GameOverScreen", false, false, true) #Run the game-over screen
		actor.instance.queue_free() #...destroy the Player by removing from memory.

		
func update_state(_delta : float) -> void:
	pass

func exit_state() -> void:
	pass #Ain't no exit from death!
