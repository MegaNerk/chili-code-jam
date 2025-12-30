extends Node

@export var menu_music_tracks : AudioStreamPlaylist
@export var in_game_music_tracks : AudioStreamPlaylist

@export var music_player : AudioStreamPlayer

func _ready():
	STATE.state_changed.connect(on_state_changed)
	SETTINGS.settings_updated.connect(sync_to_audio_settings)
	sync_to_audio_settings()
	#add_child(music_player)
	#music_player.bus = "Music"

func start_music():
	#music_player.stream = music_tracks[0]
	music_player.play()

func on_state_changed(old_state, new_state):
	if new_state == old_state:
		return
	music_player.stop()
	match new_state:
		STATE.GAME_STATE.MAIN_MENU:
			music_player.stream = menu_music_tracks
		STATE.GAME_STATE.IN_GAME:
			music_player.stream = in_game_music_tracks
	music_player.play()

func sync_to_audio_settings():
	set_bus_volume("Master", SETTINGS.settings_data["audio"]["master_volume"])
	set_bus_volume("Music", SETTINGS.settings_data["audio"]["music_volume"])
	set_bus_volume("SFX", SETTINGS.settings_data["audio"]["sfx_volume"])

func set_bus_volume(bus_name : String, new_vol : float):
	var db_vol = linear_to_db(new_vol)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db_vol)
