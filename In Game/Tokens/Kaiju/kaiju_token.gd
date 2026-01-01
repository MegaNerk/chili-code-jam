extends TokenPin
class_name KaijuToken

@export var nav_agent : NavigationAgent2D
@export var char_body : CharacterBody2D
var speed = 100
var water_speed = 150
var land_speed = 70
var target_position = Vector2.ZERO
var game : Game
var time_cordinator : TimeCoordinator

var my_kaiju : Kaiju

func _ready():
	super()
	nav_agent.link_reached.connect(_traveled_water_way)
	game = get_tree().current_scene as Game

func _traveled_water_way(details):
	print("Kaiju {name} used the {waterway}".format({"name" : char_body.name, "waterway" : details.rid}))

func _update_speed():
	match _get_current_region().navigation_layers:
		1:
			speed = water_speed
		2:
			speed = land_speed
		_:
			print("Not on Nav Mesh")

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		char_body.velocity = Vector2.ZERO
		return

	#_update_speed()
	if nav_agent.is_target_reachable():
		var next_point = nav_agent.get_next_path_position()
		var direction = char_body.global_position.direction_to(next_point)
		char_body.velocity = direction * speed * game.time_coordinator.current_speed * delta * game.time_coordinator.ticks_per_day
	else:
		char_body.velocity = Vector2.ZERO
		
	char_body.move_and_slide()

func _get_current_region():
	var cur_reg = NavigationServer2D.agent_get_map(nav_agent.get_rid())
	var closest = NavigationServer2D.map_get_closest_point_owner(cur_reg, char_body.global_position)
	var object_instance = instance_from_id(NavigationServer2D.region_get_owner_id(closest)) as NavigationRegion2D
	return object_instance
