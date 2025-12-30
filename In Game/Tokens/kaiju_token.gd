extends Control

@export var pin_click_mask : Texture2D
var pin_click_mask_image : Image

func _ready():
	pin_click_mask_image = pin_click_mask.get_image()

func on_hovered():
	self.scale = Vector2(0.35,0.35)

func on_stop_hovered():
	self.scale = Vector2(0.25,0.25)

func _has_point(point):
	if pin_click_mask == null or pin_click_mask.get_size() == Vector2.ZERO:
		return false
	
	var pin_click_mask_image = pin_click_mask.get_image()
	var mask_size : Vector2 = pin_click_mask_image.get_size()
	
	var uv = point/size
	var point_on_mask = (uv * mask_size).floor()
	
	if not Rect2(Vector2.ZERO, mask_size).has_point(point_on_mask):
		return false
	
	var point_r_value = pin_click_mask_image.get_pixelv(point_on_mask).r
	
	return point_r_value < 0.5
