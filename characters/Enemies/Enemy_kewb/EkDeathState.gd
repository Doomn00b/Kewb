extends State
class_name EkDeathState
@export_category("Put Actor, aka Enemy-prefab here")
@export var actor: EnemyKewb #We put our "Actor" here, in this case, our enemy-Kewb.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func enter_state() -> void:
	actor.animator.play("ek_dead")
	await get_tree().process_frame #Wait for one frame before...
	actor.queue_free() #...we remove Enemy from memory, destroying it.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_state(_delta: float) -> void:
	pass
	
	
func exit_state() -> void:
	#We NEVER exit this state. This is the end...
	pass
