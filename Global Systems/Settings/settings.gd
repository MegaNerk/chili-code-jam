extends CanvasLayer

signal settings_opened
signal settings_closed
signal settings_saved
signal settings_updated

var settings_menu_scene = preload("res://Global Systems/Settings/Settings Menu/settings_menu.tscn")
var cur_settings_menu : Control = null

var settings_data := {
	"audio" : {
		"master_volume" : 0.5,
		"music_volume" : 0.5,
		"sfx_volume" : 0.5
	}
}

var CFG_PATH : String = "user://settings.cfg"

func _ready():
	load_settings_from_config()

func open_settings():
	if cur_settings_menu:
		return
	cur_settings_menu = settings_menu_scene.instantiate()
	add_child(cur_settings_menu)
	cur_settings_menu.save_settings.connect(save_settings_from_menu)
	cur_settings_menu.close_settings.connect(close_settings)
	cur_settings_menu.volume_slider_changed.connect(sync_volumes_with_settings_menu)
	emit_signal("settings_opened")

func close_settings():
	cur_settings_menu.queue_free()
	load_settings_from_config()
	emit_signal("settings_closed")

func save_settings_from_menu():
	if !cur_settings_menu:
		return
	save_settings_to_config()
	emit_signal("settings_saved")

func save_settings_to_config():
	var config = ConfigFile.new()
	
	for setting_type in settings_data.keys():
		for setting in settings_data[setting_type].keys():
			config.set_value(setting_type,setting,settings_data[setting_type][setting])
	config.save(CFG_PATH)

func load_settings_from_config():
	var config = ConfigFile.new()
	if config.load(CFG_PATH) != OK:
		return
	for setting_type in settings_data.keys():
		for setting in settings_data[setting_type].keys():
			if config.has_section_key(setting_type,setting):
				settings_data[setting_type][setting] = config.get_value(setting_type,setting)
	emit_signal("settings_updated")

func sync_volumes_with_settings_menu(slider_type, new_vol):
	var vol_dict = cur_settings_menu.get_volumes()
	settings_data["audio"]["master_volume"] = vol_dict["master"]
	settings_data["audio"]["music_volume"] = vol_dict["music"]
	settings_data["audio"]["sfx_volume"] = vol_dict["sfx"]
	emit_signal("settings_updated")
