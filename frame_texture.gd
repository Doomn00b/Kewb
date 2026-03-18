#This custom-class allows us to animate the Atlastexture used for the health-hud.
class_name FrameTexture
extends AtlasTexture

var frame : int = 0: #We make a variable that stores an integer of "frames"
	set(new_frame):
		frame = new_frame
		region.position.x = region.size.x * frame 
		#The new frame is based on moving the AtlasTexture region on the X-axis.
