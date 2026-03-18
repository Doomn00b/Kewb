#class_name HealthHud
extends Control

@onready var max_hp : int = Player.instance.PCMAX_HEALTH #We get the max-health value from the player.
@onready var hp : int = Player.instance.health #We get the current player-health.
@onready var healthbar0 : TextureRect = %HSpriteTexture1 #We get the first atlas-texture of the BASE health-bar
@onready var healthbar1 : TextureRect = %HSpriteTexture0 #We get the second atlas-texture for the fully UPGRADED health-bar


#var frame : int = 0

var frame : int = 0:
	set(new_frame):
		frame = new_frame
		healthbar0.texture.frame = clamp(frame, 0, 8)
		healthbar1.texture.frame = clamp(frame - 8, 0, 8)


func update_health_bar() -> void:
	@warning_ignore("integer_division")
	var hp_value : int = (hp / max_hp) #Value that decides back or forwards on the health-animation.
	if hp_value < max_hp :
		print("Frame")
		self.frame += 1
	
#Below is a test-function to see if the method of using a "frame-texture" works. (it does)
#func _input(_event: InputEvent) -> void:
	##print("hello")
	#if Input.is_action_just_pressed("attack"):
		#print("Frame")
		#self.frame += 1
