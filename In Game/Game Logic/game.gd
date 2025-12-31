extends Control

@export var game_ui : InGameUI
@export var event_director : EventDirector
@export var city_director : CityDirector
@export var time_coordinator : TimeCoordinator
@export var news_reporter : NewsReporter

var active_kaiju : Array[Kaiju]
var active_buildings : Array[Building]

var food : int
var fear : int

func _ready():
	game_ui.speed_toggled.connect(change_speed)

func change_speed(new_speed):
	print(str(new_speed))
