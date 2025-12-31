extends Control

@export var event_director : EventDirector
@export var city_director : CityDirector
@export var time_coordinator : TimeCoordinator

var active_kaiju : Array[Kaiju]
var active_buildings : Array[Building]

var food : int
var fear : int
