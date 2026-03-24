class_name PlayerHud
extends CanvasLayer

static var instance : PlayerHud

func _init() -> void:
	instance = self

func _process(_delta: float) -> void:
	#if Player.instance.visible == false:
		#self.instance.hide()
	pass
