extends Control

var frame : int = 0:
	set(new_frame):
		frame = new_frame
		%HSpriteTexture1.texture.frame = clamp(frame, 0, 8)
		%HSpriteTexture0.texture.frame = clamp(frame - 8, 0, 8)
		#%HSpriteTexture1.texture.region.position.x = 36 * clamp(frame, 0, 8)
		#%HSpriteTexture0.texture.region.position.x = 36 * clamp(frame - 8, 0, 8)

func _input(event: InputEvent) -> void:
	print("hello")
	if Input.is_action_just_pressed("attack"):
		print("Frame")
		self.frame += 1
