@tool
@icon("res://interactables/Buttons/switch_symbol.png")
class_name Buttons
extends Node2D

signal button_activated

const DOOR_BUTTON_AUDIO = preload("res://interactables/Buttons/block_hit.ogg")
@onready var butt_sprite: Sprite2D = %VertButtSprite
@onready var butt_area = %ButtonArea2D

var is_open : bool = false

func _ready() -> void:
	#if SaveManager.persistent_data.get_or_add("door_01", "closed") == "open":
	#if SaveManager.
	pass

#If the door button has been punched, the door should stay open.
#But if the door hasn't been punched before, it should be closed.
#The tutorial talks to the save-manager to get a value from persistent data, 
#which says if the numbered door (door_01 for instance) is saved as open or close.
