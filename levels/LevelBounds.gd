@tool
@icon("res://levels/level_bounds_symbol.png")
#This script helps define a bounding-box for the Camera. 
#It draws a blue box only visible in the editor to show where that is.
class_name LevelBounds
extends Node2D

@export_range( 512, 2048, 32,"suffix:px" ) var width :int = 512 : set = _on_width_changed  #Minimum to maximum width, in steps of 32 pixels; based on ref-resolution.
@export_range( 288, 2016, 32,"suffix:px" ) var height :int = 288 : set = _on_height_changed

@export_range( -2048, 2048, 32) var x_position : int = 0 : set = _on_xpos_changed
@export_range( -2016, 2016, 32) var y_position : int = 0 : set = _on_ypos_changed



func _ready():
	#region guard-clause, so we don't block if we're not playing game.
	if Engine.is_editor_hint():
		z_index = 256 #We make the bbox always visible above everything else in the editor.
		return
	#endregion
	# Check for and get reference to camera.
	#var camera : Camera2D = Player.instance.player_cam #We get the camera from the player.
	var camera : Camera2D = null
	while !camera:
		await get_tree().process_frame #We wait for 1 frame...
		camera = get_viewport().get_camera_2d() #... and then assign whichever 
		#camera = Player.instance.player_cam
	
	# Update camera's limits
	camera.limit_left = int (global_position.x)
	camera.limit_top = int (global_position.y)
	camera.limit_right = int (global_position.x) + width
	camera.limit_bottom = int (global_position.y) + height

func _draw():
	if Engine.is_editor_hint():
		#draw a rectangle
		var bbox : Rect2 = Rect2( Vector2.ZERO, Vector2(width, height) )
		draw_rect( bbox, Color(0.0, 0.157, 1.0, 0.6), false, 3 ) #We get the draw-function to draw  bbox blue, slightly transparent.
		draw_rect( bbox, Color(0.157, 0.612, 1.0, 1.0), false, 1 )
		
	pass

func _on_width_changed( new_width : int ):
	width = new_width
	queue_redraw()
	
func _on_height_changed( new_height: int ):
	height = new_height
	queue_redraw()
	
func _on_xpos_changed( new_xpos: int ):
	move_local_x(new_xpos)
	
	
func _on_ypos_changed( new_ypos: int ):
	move_local_y(new_ypos)
	
