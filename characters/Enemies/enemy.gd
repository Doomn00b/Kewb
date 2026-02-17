@abstract 
class_name Enemy
extends CharacterBody2D

signal enemy_died()

@abstract func _ready() -> void

@abstract func setup_enemy(pos : Vector2 = Vector2.ZERO) #The enemies spawn-function.
