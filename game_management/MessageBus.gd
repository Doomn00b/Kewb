#This will create a node that can broadcast a signal that an interaction has occurred, 
#and ANY other node can listen in, without a need to look for an instance of the player.
#This entire class is a container for signals.
class_name MessageBus
extends Node

@warning_ignore("unused_signal")
signal player_interacted( player: Player)

@warning_ignore("unused_signal")
signal input_hint_changed( hint : HintMsgEnum.E) #variable hint should be based on a hint-message ENUM.

@warning_ignore("unused_signal")
signal player_health_changed() #Tells that the health has changed.

@warning_ignore("unused_signal")
signal restart_now()

static var instance

func _init() -> void:
	instance = self
