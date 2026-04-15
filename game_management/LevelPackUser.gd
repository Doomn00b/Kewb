#TODO:
	#Integrate this script into SaveManager.
	#How do I combine it with the current variables in SaveManager?
@icon("res://game_management/levelpack_symbol.png")
class_name LevelPackUser
extends Node

const SAVE_PATH := "res://SavedPackage.tscn"

@onready var ori_lvl = GameManager.instance.current_level2d #The original level (that shall be packed), is the current one.
#@onready var clone_parent = %World #Can't give Main a unique name to ref, since it's outside the tree, I guess?
#Clone parent will hold the new packed-scene instance after it's been created.

static var instance : LevelPackUser

func _init() -> void:
	instance = self

func save_package(): #Save_pressed button
	var created_package = LevelPacker.create_package(ori_lvl) 
	print_debug("Created level package.")
	var error_save:= ResourceSaver.save(created_package, SAVE_PATH)
	if error_save != OK:
		push_error("An error occurred while saving the Level to disk.")
	print_debug("Packed level saved.")

func load_package(): #Instance_pressed (button) puts something up on screen, loads instance
	var package_instance = null #What TYPE is this, again??
	#if !created_package:
		#print_debug("No packed scene to Load.")
		#return
	var packed_level = ResourceLoader.load(SAVE_PATH) #We make the created package the already saved file.
	
	if package_instance != null: #Before we unpack we check so there isn't already an instance, (somehow)...
		package_instance.queue_free() #...remove it, since we don't need it.
	#GameManager.instance.load_level2D(save_game, true)
	#package_instance = created_package.instantiate() #We make the package-instance the newly created one.
	
	World.instance.add_child(package_instance) #We make the packed scene a child of Main (clone_parent).
	
	print_debug("Packed level loaded and unpacked.")
	
#Function for testing the saving and loading, with keyboard shortcuts, instead of UI and checkpoints.
#func _unhandled_input(_event: InputEvent) -> void:
	##5 for saving
	#if Input.is_action_just_pressed("save_pack_test"):
		#print("save")
		#save_package()
	##9 for loading
	#if Input.is_action_just_pressed("load_pack_test"):
		#print("load")
		#load_package()
