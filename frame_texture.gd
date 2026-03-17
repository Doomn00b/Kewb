class_name FrameTexture
extends AtlasTexture

var frame : int = 0:
	set(new_frame):
		frame = new_frame
		region.position.x = region.size.x * frame
