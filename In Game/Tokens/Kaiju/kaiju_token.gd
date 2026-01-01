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