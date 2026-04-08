@tool
@icon("res://game_management/upgradel_symbol.png")
class_name AbilityUpgrade
extends Node2D
var anim_dict : Dictionary[UpgradeEnum.E, String] = {
	UpgradeEnum.E.POWER_PUNCH : "pp_shine",
	UpgradeEnum.E.UPPERCUT : "uc_shine",
	UpgradeEnum.E.CHARGE_JUMP : "cj_shine"
}
@export_category("Use the list to select which upgrade this is.")
@export var upgrade_type : UpgradeEnum.E = UpgradeEnum.E.POWER_PUNCH:
	set(value):
		upgrade_type = value
		_set_animation()

@onready var ability_anim: AnimationPlayer = %AbilityAnim
@onready var player : Player = Player.instance

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_set_animation()
	#Add PERSISTENCE
	#Connect destroy on pickup.

func _set_animation():
	if !ability_anim:
		ability_anim = %AbilityAnim
	ability_anim.play(anim_dict[upgrade_type]) #Testing to see if the animation is being played.

func _on_body_entered(body: Node2D) -> void: #When something walks into the pickup.
	if body.is_in_group("playerGroup"): #If the body that enters the area is the Player, then...
		_picked_up() #...we pick up the item.

func _picked_up(): #Is this even a thing...? The tutorial has orbs you break and then pick up, I just pick up.
	#Add persistence
	#Reward ability
	_reward_ability()
	self.queue_free()
	
func _reward_ability() -> void: #This function matches the upgrade-enums with the player bools. (for activating them)
	match upgrade_type:
		UpgradeEnum.E.POWER_PUNCH:
			player.enable_powerpunch()
		UpgradeEnum.E.UPPERCUT:
			player.enable_uppercut()
		UpgradeEnum.E.CHARGE_JUMP:
			player.enable_chargejump()
