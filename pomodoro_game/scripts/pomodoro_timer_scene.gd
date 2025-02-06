extends Control

@onready var work_time_spinbox = $VBoxContainer/WorkTimeContainer/WorkTimeSpinBox
@onready var rest_time_spinbox = $VBoxContainer/RestTimeContainer/RestTimeSpinBox
@onready var timer_label       = $VBoxContainer/TimerLabel
@onready var start_button      = $VBoxContainer/ButtonsContainer/StartButton
@onready var pause_button      = $VBoxContainer/ButtonsContainer/PauseButton
@onready var sound_player      = $VBoxContainer/SoundEffectPlayer
@onready var mood_option       = $VBoxContainer/MoodContainer/MoodOption
@onready var diary_entry       = $VBoxContainer/DiaryEntry
@onready var save_button: Button = $VBoxContainer/HBoxContainer/SaveButton
@onready var save_to_json_button: Button = $VBoxContainer/HBoxContainer/SaveToJSONButton
@onready var reset_button: Button = $VBoxContainer/ButtonsContainer/ResetButton
@onready var load_from_json_button: Button = $VBoxContainer/HBoxContainer/LoadFromJSONButton
@onready var exit_button: Button = $VBoxContainer/HBoxContainer/ExitButton

# Track whether we're in "work" or "rest" mode
var current_mode = "work"

# Default durations in seconds
var default_work_duration = 25 * 60
var default_rest_duration = 5 * 60

# Time left in the current countdown
var remaining_time = 0.0

# Keeps track of how many total seconds of work have been completed
var total_time_studied = 0

# For pausing
var paused = false
var pause_count = 0

func _ready():
	# Set default SpinBox values
	work_time_spinbox.value = 25
	rest_time_spinbox.value = 5

	# Update label
	update_timer_label()

func _process(delta: float) -> void:
	# Update timer logic in a separate function
	if not paused and remaining_time > 0:
		_update_timer_loop(delta)

func _update_timer_loop(delta: float) -> void:
	# Decrement the timer
	remaining_time -= delta
	
	# If the timer just ran out, handle transitions and sound
	if remaining_time <= 0:
		remaining_time = 0
		
		# Check which mode just ended
		if current_mode == "work":
			# Play end-of-work sound
			SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_END_WORK)
			# Add to total studied
			total_time_studied += int(work_time_spinbox.value * 60)
			# Switch to rest
			current_mode = "rest"
			remaining_time = int(rest_time_spinbox.value * 60)
		else:
			# Rest just ended
			SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_END_REST)
			# Switch to work but let user start manually
			current_mode = "work"

	# Update timer label every frame
	update_timer_label()

func _on_start_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	# If there's no active countdown, set it based on mode
	if remaining_time <= 0:
		if current_mode == "work":
			remaining_time = int(work_time_spinbox.value * 60)
		else: # rest mode
			remaining_time = int(rest_time_spinbox.value * 60)

	paused = false

func _on_save_to_json_button_pressed() -> void:
	# Saves current session info to a JSON file in /JSON/
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_SAVE_TO_JSON)
	save_session_data()

func _on_pause_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_PAUSE)
	paused = !paused
	if paused:
		pause_count += 1

func update_timer_label():
	# Replace // with / if needed
	var minutes = int(remaining_time / 60)
	var seconds = int(remaining_time) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]



func save_session_data():
	var now_dict = Time.get_datetime_dict_from_system()
	var year     = now_dict.year
	var month    = now_dict.month
	var day      = now_dict.day
	var hour     = now_dict.hour
	var minute   = now_dict.minute
	var second   = now_dict.second

	var date_str = "%04d-%02d-%02d_%02d-%02d-%02d" % [year, month, day, hour, minute, second]

	# Build a data dictionary
	var data = {
		"date": "%04d-%02d-%02d" % [year, month, day],
		"time": "%02d:%02d:%02d" % [hour, minute, second],
		"some_extra_key": "Your other info here"
	}

	var file_path = "res://JSON/%s.json" % date_str
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data) + "\n")
		file.close()
		prints("Session data saved to:", file_path)
	else:
		printerr("Error saving session data.")


func _on_reset_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	pass # Replace with function body.


func _on_load_from_json_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	pass # Replace with function body.

func _on_save_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	get_tree().quit()
