extends Control

signal hovered
signal hover_stopped
signal left_clicked
signal right_clicked

@export var pin_click_mask : Texture2D
var pin_click_mask_image : Image

@export var pathing_line : PathingLine
var selected : bool = false

func _ready():
	pin_click_mask_image = pin_click_mask.get_image()

func _process(delta):
	if selected:
		pathing_line.source = Vector2(175.0,417.0)
		pathing_line.target = get_local_mouse_position()

func on_hovered():
	self.scale = Vector2(0.35,0.35)
	emit_signal("hovered")

func on_stop_hovered():
	if selected == false:
		self.scale = Vector2(0.25,0.25)
	emit_signal("hover_stopped")

func get_selected():
	selected = true
	pathing_line.visible = true

func get_unselected():
	pathing_line.visible = false
	selected = false


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_selected()
			emit_signal("left_clicked")
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			get_unselected()
			emit_signal("right_clicked")

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
