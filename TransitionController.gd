class_name TransitionController
extends Control

@export var background: ColorRect #We get the coloured rectangle to use as transition-background.
@export var animation_player: AnimationPlayer #We get the animation-player to fade the background in and out.

static var instance : TransitionController

func _init() -> void:
	instance = self

#This function will reference the animationplayer and play the fade-in/out animations.
func transition(animation: String, seconds: float) -> void:
	#For the length of the animation, we are adjusting the animation-speed by...
	animation_player.play(animation, -0.8, 0.8 / seconds) #...adjusting the animation-speed by dividing it with our desired time-length. (0.8 seconds)
	
