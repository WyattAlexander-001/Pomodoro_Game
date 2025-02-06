extends Node

@onready var playing_audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


const SFX_KEY_CLICK = preload("res://assets/sound/sfx/key_click.mp3")
const SFX_SAVE_TO_JSON = preload("res://assets/sound/sfx/old_radio_click.mp3")
const SFX_PAUSE = preload("res://assets/sound/sfx/pause_sound.mp3")
const SFX_END_REST = preload("res://assets/sound/sfx/rest_over.mp3")
const SFX_END_WORK = preload("res://assets/sound/sfx/success_pomodoro.mp3")

func _ready() -> void:
	playing_audio.volume_db = -5.0
	playing_audio.bus = "Master" 

func play_sound_effect(sound_stream: AudioStream) -> void:
	playing_audio.stream = sound_stream
	playing_audio.play()
	
