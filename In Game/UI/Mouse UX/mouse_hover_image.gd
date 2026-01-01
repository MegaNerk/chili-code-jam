extends TextureRect
class_name MouseHoverImage

func _process(delta):
	if !visible:
		return
	position = get_global_mouse_position()
	position -= size/2
