extends Control

@export var game_ui : InGameUI
@export var event_director : EventDirector
@export var city_director : CityDirector
@export var time_coordinator : TimeCoordinator
@export var news_reporter : NewsReporter

var ticks_elapsed : int

var active_kaiju : Array[Kaiju]
var active_buildings : Array[Building]

var food : int
var fear : int

func change_speed(new_speed):
	time_coordinator.current_speed = new_speed

func date_changed(new_date_string):
	game_ui.update_date_display(new_date_string)

func on_tick_passed():
	ticks_elapsed += 1
