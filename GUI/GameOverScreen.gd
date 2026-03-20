class_name GameOverScreen
extends Control

@onready var load_button : Button = %LoadButton
@onready var bck_ttl_button : Button = %BackToTitleButton
@onready var rst_button : Button = %RestartButton
#@onready var g_o_screen : Control = self

var g_o_visible : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Coding in VISIBILITY might be bullshit... 
	#since I've got a GameManager that can turn on and off GUI-scenes...
	#but here goes...
	load_button.pressed.connect(_on_load_pressed) #We connect up the buttons to functions.
	bck_ttl_button.pressed.connect(_on_back_pressed)
	rst_button.pressed.connect(_on_rst_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_load_pressed(_save_game):
	GameManager.instance.load_level2D(_save_game, true)
	#Run the load_level2D function from GameManager, to load a previous savegame.
	print_debug("Pressed Load game.")
	
func _on_back_pressed():
	#Clear game over screen -- we'll use GameManager again.
	#Load the main menu, do not delete game-overscreen, make it invisible but disable processing, run a transition.
	GameManager.instance.change_gui_scene("MainMenu", false, false, true)
	print_debug("Pressed Back to MainMenu")
	
func _on_rst_pressed():
	MessageBus.instance.restart_now.emit() 
	#We tell the MessageBus to send the request to reset.
	#This will then be picked up by gameManager and it will set a bool to reset scenes.
	print_debug("Pressed Restart")
