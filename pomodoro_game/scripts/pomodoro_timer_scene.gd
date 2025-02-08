extends Control

@onready var pomodoro_count_label: Label = $VBoxContainer/VBoxContainer/PomodoroCountLabel
@onready var total_studied_label: Label = $VBoxContainer/VBoxContainer/TotalStudiedLabel

@onready var work_time_spinbox = $VBoxContainer/WorkTimeContainer/WorkTimeSpinBox
@onready var rest_time_spinbox = $VBoxContainer/RestTimeContainer/RestTimeSpinBox
@onready var timer_label: Label = $VBoxContainer/TimerContainer/TimerLabel
@onready var start_button       = $VBoxContainer/ButtonsContainer/StartButton
@onready var pause_button       = $VBoxContainer/ButtonsContainer/PauseButton
@onready var mood_option        = $VBoxContainer/MoodContainer/MoodOption
@onready var diary_entry        = $VBoxContainer/DiaryEntry
@onready var reset_button       = $VBoxContainer/TimerContainer/ResetButton
@onready var exit_button: Button = $VBoxContainer/HBoxContainer/ExitButton
@onready var save_button: Button = $VBoxContainer/HBoxContainer/SaveButton

var paused = false

func _ready():
	var sg = SaveDataForPlayer.save_game
	# Use the loaded data to set up spin boxes, labels, etc.
	work_time_spinbox.value = sg.default_work_minutes
	rest_time_spinbox.value = sg.default_rest_minutes
	update_timer_label(sg.remaining_time)
	update_pomodoro_count_label()
	# Possibly set mood OptionButton, diary text, etc.

func _process(delta: float) -> void:
	var sg = SaveDataForPlayer.save_game
	
	# Only decrement if not paused and there's time left
	if not paused and sg.remaining_time > 0:
		sg.remaining_time -= delta
		
		# Check if time has run out
		if sg.remaining_time <= 0:
			sg.remaining_time = 0
			
			# If the current mode was "work", that means we just finished a Pomodoro
			if sg.current_mode == "work":
				SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_END_WORK)
				sg.total_time_pomodoros_completed += 1
				update_pomodoro_count_label()
				
				# Log the end of a work session
				prints("=== Work session finished ===")
				prints("Pomodoros completed so far: ", sg.total_time_pomodoros_completed)
				
				# Add the total studied time in seconds
				sg.total_time_studied += int(work_time_spinbox.value * 60)
				prints("Total time studied (seconds) so far: ", sg.total_time_studied)
				
				# Switch to rest
				sg.current_mode = "rest"
				sg.remaining_time = int(rest_time_spinbox.value * 60)
				prints("Switched to rest for %d seconds." % sg.remaining_time)
				prints("")

			else:
				# Current mode was "rest", so we just finished a rest period
				SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_END_REST)
				prints("=== Rest session finished ===")
				prints("Switching to work mode.")
				prints("")
				
				sg.current_mode = "work"
				# (Optionally set sg.remaining_time if you want automatic next cycle)
			
			# After the session ends, write save to persist changes
			sg.write_savegame()
	
	# Update the timer display each frame
	update_timer_label(sg.remaining_time)


func update_pomodoro_count_label():
	var sg = SaveDataForPlayer.save_game
	pomodoro_count_label.text = "Pomodoros Completed: %d" % sg.total_time_pomodoros_completed
	print("Total Poms Done:")
	print(sg.total_time_pomodoros_completed)
	print("Total Time Done:")
	print(sg.total_time_studied)
	



func update_timer_label(time_left: float):
	var minutes = int(time_left / 60)
	var seconds = int(time_left) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func _on_start_button_pressed():
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	var sg = SaveDataForPlayer.save_game
	if sg.remaining_time <= 0:
		if sg.current_mode == "work":
			sg.remaining_time = int(work_time_spinbox.value * 60)
		else:
			sg.remaining_time = int(rest_time_spinbox.value * 60)
	paused = false

func _on_pause_button_pressed():
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_PAUSE)
	paused = !paused
	if paused:
		SaveDataForPlayer.save_game.pause_count += 1

func _on_reset_button_pressed():
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)

	paused = true
	var sg = SaveDataForPlayer.save_game
	sg.current_mode = "work"
	sg.remaining_time = 0
	sg.default_work_minutes = 25
	sg.default_rest_minutes = 5
	sg.total_time_studied = 0
	sg.pause_count = 0
	sg.total_time_pomodoros_completed = 0
	sg.mood = "Happy"
	sg.diary = ""

	work_time_spinbox.value = 25
	rest_time_spinbox.value = 5
	mood_option.select(find_text_in_option_button(mood_option, "Happy"))
	diary_entry.text = ""
	update_timer_label(0)

	# Update the label to reset count
	update_pomodoro_count_label()

	sg.write_savegame()

	sg.write_savegame()

func _on_mood_option_item_selected(index: int):
	var sg = SaveDataForPlayer.save_game
	sg.mood = mood_option.get_item_text(index)
	sg.write_savegame()

func _on_diary_entry_text_changed(new_text: String):
	var sg = SaveDataForPlayer.save_game
	sg.diary = new_text
	sg.write_savegame()

func find_text_in_option_button(option_button: OptionButton, text_to_find: String) -> int:
	for i in range(option_button.item_count):
		if option_button.get_item_text(i) == text_to_find:
			return i
	return -1

func _on_exit_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	get_tree().quit()

func _on_save_button_pressed() -> void:
	SoundEffectManager.play_sound_effect(SoundEffectManager.SFX_KEY_CLICK)
	SaveDataForPlayer.save_game.write_savegame()
