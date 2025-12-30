extends CanvasLayer

signal settings_opened
signal settings_closed
signal settings_saved

var settings_menu_scene = preload("res://Global Systems/Settings/Settings Menu/settings_menu.tscn")
var cur_settings_menu : Control = null

var master_volume : float = 50.0
var music_volume : float = 50.0
var sfx_volume : float = 50.0

func open_settings():
	if cur_settings_menu:
		return
	cur_settings_menu = settings_menu_scene.instantiate()
	add_child(cur_settings_menu)
	cur_settings_menu.save_settings.connect(save_settings)
	cur_settings_menu.close_settings.connect(close_settings)
	emit_signal("settings_opened")

func close_settings():
	cur_settings_menu.queue_free()
	emit_signal("settings_closed")

func save_settings():
	if !cur_settings_menu:
		return
	var vol_dict = cur_settings_menu.get_volumes()
	master_volume = vol_dict["master"]
	music_volume = vol_dict["music"]
	sfx_volume = vol_dict["sfx"]
	emit_signal("settings_saved")
