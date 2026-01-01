extends CharacterBody2D
class_name Kaiju

@export var kaiju_resource : Kaiju_Res = preload("res://In Game/Kaiju/All Kaiju/Octeyepuss.tres")

@onready var token : KaijuToken = $KaijuToken
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
var local_speed : int = 100
var current_region : NavigationRegion2D

signal changed_region

func _ready():
	nav_agent.link_reached.connect(_on_link_reached)
	nav_agent.target_reached.connect(_on_target_reached)

func _update_movement():
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	if nav_agent.is_target_reachable():
		var next_point = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_point)
		velocity = direction * local_speed
	move_and_slide()

func _update_region():
	var region = _get_current_region()
	if current_region == region:
		return
		
	current_region = region
	changed_region.emit()
	
	match current_region.navigation_layers:
		1:
			local_speed = kaiju_resource.water_speed
		2:
			local_speed = kaiju_resource.land_speed

func _get_current_region() -> NavigationRegion2D:
	var current_region = _closest_region_to_position(nav_agent, global_position)
	return current_region

func _closest_region_to_position(agent, target_position) -> NavigationRegion2D:
	var map_rid = NavigationServer2D.agent_get_map(agent.get_rid())
	var region_rid = NavigationServer2D.map_get_closest_point_owner(map_rid, target_position)
	return instance_from_id(NavigationServer2D.region_get_owner_id(region_rid)) as NavigationRegion2D

func _on_link_reached(details):
	print("Kaiju {name} used the {waterway}".format({"name" : name, "waterway" : details.rid}))

func _on_target_reached():
	pass
	
func _on_navigation_finished():
	pass

func _target_location(new_location):
	pass

#func _get_current_region():
	#var cur_reg = NavigationServer2D.agent_get_map(nav_agent.get_rid())
	#var closest = NavigationServer2D.map_get_closest_point_owner(cur_reg, char_body.global_position)
	#var object_instance = instance_from_id(NavigationServer2D.region_get_owner_id(closest)) as NavigationRegion2D
	#return object_instance

#func _physics_process(delta):
	#if nav_agent.is_navigation_finished():
		#char_body.velocity = Vector2.ZERO
		#return
#
	##_update_speed()
	#if nav_agent.is_target_reachable():
		#var next_point = nav_agent.get_next_path_position()
		#var direction = char_body.global_position.direction_to(next_point)
		#char_body.velocity = direction * speed * game.time_coordinator.current_speed * delta * game.time_coordinator.ticks_per_day
	#else:
		#char_body.velocity = Vector2.ZERO
		#
	#char_body.move_and_slide()
