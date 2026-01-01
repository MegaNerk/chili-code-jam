extends Control
class_name KaijuToken

signal hovered
signal hover_stopped
signal left_clicked
signal right_clicked
signal selected
signal unselected

@export var pin_click_mask : Texture2D
@export var nav_agent : NavigationAgent2D
@export var char_body : CharacterBody2D
var speed = 200
var target_position = Vector2.ZERO
var pin_click_mask_image : Image

var currently_selected : bool = false

var my_kaiju : Kaiju

func _ready():
	pin_click_mask_image = pin_click_mask.get_image()

func _physics_process(delta):
	if nav_agent.is_target_reachable():
		print("Moving")
		var next_point = nav_agent.get_next_path_position()
		var direction = char_body.global_position.direction_to(next_point)
		char_body.velocity = direction * speed
	else:
		char_body.velocity = Vector2.ZERO
		#velocity = Vector2.ZERO # Stop if no path

	#move_and_slide()

func on_hovered():
	self.scale = Vector2(1.1,1.1)
	emit_signal("hovered")

func on_stop_hovered():
	if currently_selected == false:
		self.scale = Vector2(1,1)
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
	
	var pin_click_mask_image = pin_click_mask.get_image()
	var mask_size : Vector2 = pin_click_mask_image.get_size()
	
	var uv = point/size
	var point_on_mask = (uv * mask_size).floor()
	
	if not Rect2(Vector2.ZERO, mask_size).has_point(point_on_mask):
		return false
	
	var point_r_value = pin_click_mask_image.get_pixelv(point_on_mask).r
	
	return point_r_value < 0.5
