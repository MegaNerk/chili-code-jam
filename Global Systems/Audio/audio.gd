extends Node

@export var menu_music_tracks : AudioStreamPlaylist
@export var in_game_music_tracks : AudioStreamPlaylist
@export var credits_music : AudioStream

@export var sfx_library : SFX_Library

@export var music_player : AudioStreamPlayer
@export var sfx_player : AudioStreamPlayer

func _ready():
	STATE.state_changed.connect(on_state_changed)
	SETTINGS.settings_updated.connect(sync_to_audio_settings)
	sync_to_audio_settings()

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

func play_sfx_once(sfx_to_play : AudioStream):
	var temp_sfx_player = AudioStreamPlayer.new()
	temp_sfx_player.bus = "SFX"
	add_child(temp_sfx_player)
	temp_sfx_player.stream = sfx_to_play
	temp_sfx_player.play()
	temp_sfx_player.finished.connect(temp_sfx_player.queue_free)
