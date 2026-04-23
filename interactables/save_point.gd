@icon("res://game_management/save_symbol.png")
class_name SavePoint
extends Node2D

@onready var sprite_anim: AnimationPlayer = %SpriteAnimPlayer
@onready var label_anim: AnimationPlayer = %LabelAnimPlayer
@onready var label_save: Label = %SaveGameText
@onready var save_area : Area2D = %SaveArea


func _ready() -> void:
	sprite_anim.play("save_computer")
	save_area.body_entered.connect(_on_player_entered)
	save_area.body_exited.connect(_on_player_exited)
	
func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("playerGroup"):
		label_anim.play("sp_save_game")
		print_debug("Played entered save-point.")

func _on_player_exited(body: Node2D) -> void:
	if body.is_in_group("playerGroup"):
		#label_save.hide()
		label_anim.play_backwards("sp_save_game")
		print_debug("Player exited save-point.")

func _on_player_interacted(player: Player) -> void:
	
	pass
