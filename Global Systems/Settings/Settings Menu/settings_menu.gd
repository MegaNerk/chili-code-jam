extends Control

signal save_settings
signal close_settings

signal volume_slider_changed(type, new_value)
signal menu_settings_changed(new_menu_settings)

@export var master_vol_slider : HSlider
@export var music_vol_slider : HSlider
@export var sfx_vol_slider : HSlider

@export var date_format_dropdown : OptionButton

@export var save_close_button : Button
@export var cancel_close_button : Button

var settings_menu_data := {
	"region" : {
		"date_format" : 0
	}
}

func _ready():
	sync_volumes()
	date_format_dropdown.selected = SETTINGS.settings_data["region"]["date_format"]

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

func on_master_volume_slider_changed(new_value):
	emit_signal("volume_slider_changed", "master", new_value)

func on_music_volume_slider_changed(new_value):
	emit_signal("volume_slider_changed", "music", new_value)

func on_sfx_volume_slider_changed(new_value):
	emit_signal("volume_slider_changed", "sfx", new_value)

func on_date_format_dropdown_changed(new_format):
	settings_menu_data["region"]["date_format"] = new_format
	emit_signal("menu_settings_changed", settings_menu_data)
