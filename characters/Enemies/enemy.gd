@abstract 
class_name Enemy
extends CharacterBody2D
@warning_ignore("unused_signal") #We put an ignore warning, since this is an ABSTRACT class, to be used as a template.
signal enemy_died()

@abstract func _ready() -> void

@abstract func setup_enemy(pos : Vector2 = Vector2.ZERO) #The enemies spawn-function.
