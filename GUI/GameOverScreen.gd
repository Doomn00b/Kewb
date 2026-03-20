class_name GameOverScreen
extends Control

@onready var load_button : Button = %LoadButton
@onready var bck_ttl_button : Button = %BackToTitleButton
@onready var rst_button : Button = %RestartButton
@onready var g_o_screen : Control = self

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
	#Clear game over screen -- we'll use GameManager again.
	
func _on_back_pressed():
	pass
	#Clear game over screen -- we'll use GameManager again.
func _on_rst_pressed():
	MessageBus.instance.restart_now.emit() #We tell the MessageBus to send the request to reset.
	
