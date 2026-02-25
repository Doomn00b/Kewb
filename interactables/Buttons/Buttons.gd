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
	#if SaveManager.persistent_data.
	pass
