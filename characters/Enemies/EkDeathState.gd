extends State
class_name EkDeathState

@export var actor: EnemyKewb #We put our "Actor" here, in this case, our enemy-Kewb.

signal ek_dead #Signal that says enemy is dead.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	actor._apply_gravity(delta)
	actor.move_and_slide()
	
func _exit_state() -> void:
	set_physics_process(false)
	print_debug("Enemy-kewb died!")
