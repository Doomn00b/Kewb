@tool
@icon("res://game_management/upgradel_symbol.png")
class_name AbilityUpgrade
extends Node2D
var anim_dict : Dictionary[UpgradeEnum.E, String] = {
	UpgradeEnum.E : "pp_shine",
}
@export var upgrade_type : UpgradeEnum.E = UpgradeEnum.E.POWER_PUNCH:
	set(value):
		upgrade_type = value
		_set_animation()

@onready var ability_anim: AnimationPlayer = %AbilityAnim

func _ready() -> void:
	pass

func _set_animation():
	if !ability_anim:
		ability_anim = %AbilityAnim
	ability_anim.play(anim_dict[upgrade_type])
