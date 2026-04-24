@icon("res://game_management/save_symbol.png")
class_name SavePoint
extends Node2D

@onready var sprite_anim: AnimationPlayer = %SpriteAnimPlayer
@onready var label_anim: AnimationPlayer = %LabelAnimPlayer
@onready var save_area : Area2D = %SaveArea

func _ready() -> void:
	sprite_anim.play("save_computer")
	save_area.body_entered.connect(_on_player_entered)
	save_area.body_exited.connect(_on_player_exited)
	
func _on_player_entered(_player: Player) -> void:
	if _player.is_in_group("playerGroup"):
		MessageBus.instance.input_hint_changed.emit(HintMsgEnum.E.INTERACTMSG) #We show the hint to press interact.
		label_anim.play("sp_save_game")
		print_debug("Player entered save-point.")
		MessageBus.instance.player_interacted.connect(_on_player_interacted)
		
		
func _on_player_exited(_player: Player) -> void:
	if _player.is_in_group("playerGroup"):
		MessageBus.instance.input_hint_changed.emit(HintMsgEnum.E.NO_HINT)
		label_anim.play_backwards("sp_save_game")
		print_debug("Player exited save-point.")
		#MessageBus.instance.player_interacted.disconnect(_on_player_interacted)
	
func _on_player_interacted(_player: Player) -> void:
	#MessageBus.instance.player_interacted.emit()
	#Save game
	SaveManager.instance.write_save()
	#Animation ("Game Saved")
	label_anim.play("sp_game_saved") #Run the game saved animation.
	label_anim.seek( 0 ) #In case the player hits interact-button multiple times, we go back to the beginning of the animation.
	#Audio feedback (jingle)
	pass
