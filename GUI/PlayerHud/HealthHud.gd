#class_name HealthHud
extends Control

@onready var max_hp : int = Player.instance.PCMAX_HEALTH #We get the max-health value from the player.
@onready var healthbar0 : TextureRect = %HSpriteTexture1 #We get the first atlas-texture of the BASE health-bar
@onready var healthbar1 : TextureRect = %HSpriteTexture0 #We get the second atlas-texture for the fully UPGRADED health-bar

var frame : int = 0:
	set(new_frame):
		frame = new_frame
		healthbar0.texture.frame = clamp(frame, 0, 8)
		healthbar1.texture.frame = clamp(frame - 8, 0, 8)

func _ready():
	#We connect the Player's health-updated signal to our update-health-bar function.
	Player.instance.health_updated.connect(update_health_bar)

func update_health_bar(hp : int) -> void:
	print("Frame")
	self.frame = max_hp - hp
	
