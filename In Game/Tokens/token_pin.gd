extends Control
class_name TokenPin

signal hovered
signal hover_stopped
signal left_clicked
signal right_clicked
signal selected
signal unselected

@export var pin_click_mask : Texture2D
var pin_click_mask_image : Image
var mask_size : Vector2

var currently_selected : bool = false
var default_draw_prio : int = 0

func _ready():
	pin_click_mask_image = pin_click_mask.get_image()
	mask_size = pin_click_mask_image.get_size()

func on_hovered():
	self.z_index = 100
	self.scale += Vector2(0.1,0.1)
	emit_signal("hovered")

func on_stop_hovered():
	self.scale -= Vector2(0.1,0.1)
	self.z_index = default_draw_prio
	emit_signal("hover_stopped")

func get_selected():
	currently_selected = true
	emit_signal("selected")

func get_unselected():
	currently_selected = false
	on_stop_hovered()
	emit_signal("unselected")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("left_clicked")
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			emit_signal("right_clicked")

func _has_point(point):
	if pin_click_mask == null or pin_click_mask.get_size() == Vector2.ZERO:
		return false
	
	var uv = point/size
	var point_on_mask = (uv * mask_size).floor()
	
	if not Rect2(Vector2.ZERO, mask_size).has_point(point_on_mask):
		return false
	
	var point_r_value = pin_click_mask_image.get_pixelv(point_on_mask).r
	
	return point_r_value < 0.5
