#This script manages the various splash-screens that the game has.
class_name SplashScreenManager
extends Control

@export var load_scene : PackedScene
@export var in_time : float = 0.5
@export var fade_in_time : float = 1.5
@export var pause_time : float = 1.5
@export var fade_out_time : float = 1.5
@export var out_time : float = 0.5
@export var splash_screen_container : Node

var splash_screens : Array
static var instance : SplashScreenManager
#Called when the node enters the scene tree for the first time.
func _init() -> void:
	instance = self
	
func _ready() -> void:
	get_screens()
	fade()


#This function goes through the texture-rects of the Splash-Screen-container,
#thereby letting us set properties of the screens. (such as making them invisible) 
func get_screens() -> void:
	splash_screens = splash_screen_container.get_children()
	for screen in splash_screens: #For everything called screen in the container...
		screen.modulate.a = 0.0 #Set the screens as completely transparent.

#This is for fading in and out our Splash-screens.
func fade() -> void:
	for screen in splash_screens:
		var tween = self.create_tween()
		tween.tween_interval(in_time)
		tween.tween_property(screen, "modulate:a", 1.0, fade_in_time)
		tween.tween_interval(pause_time)
		tween.tween_property(screen, "modulate:a", 0.0, fade_out_time)
		tween.tween_interval(out_time)
		await tween.finished
	#When all screens are tweened and done, we change to our new scene.
	#GameManager.instance.change_gui_scene("res://GUI/main_menu.tscn")
	#GameManager.instance.change_level2D(load_scene)
	#get_tree().change_scene_to_packed(load_scene) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

#This function lets the player skip splash-screens
func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed(): #If any key is pressed...
		GameManager.instance.change_gui_scene("res://GUI/main_menu.tscn") #We summon the GameManager's current instance, and run the change-gui function.
