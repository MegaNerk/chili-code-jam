extends Control

signal save_settings
signal close_settings

@export var master_vol_slider : HSlider
@export var music_vol_slider : HSlider
@export var sfx_vol_slider : HSlider

@export var save_close_button : Button
@export var cancel_close_button : Button

func _ready():
	sync_volumes()

func sync_volumes():
	master_vol_slider.value = SETTINGS.settings_data["audio"]["master_volume"]
	music_vol_slider.value = SETTINGS.settings_data["audio"]["music_volume"]
	sfx_vol_slider.value = SETTINGS.settings_data["audio"]["sfx_volume"]

func get_volumes() -> Dictionary:
	var vol_dict = {
		"master" : master_vol_slider.value,
		"music" : music_vol_slider.value,
		"sfx" : sfx_vol_slider.value
	}
	return vol_dict

func save_close_pressed():
	emit_signal("save_settings")
	emit_signal("close_settings")

func cancel_close_pressed():
	emit_signal("close_settings")
