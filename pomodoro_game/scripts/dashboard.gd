extends Control

@onready var pomodoros_label: Label = $VBoxContainer/PomodorosLabel
@onready var studied_label: Label   = $VBoxContainer/StudiedTimeLabel
@onready var mood_label: Label      = $VBoxContainer/MoodLabel
@onready var diary_label: Label     = $VBoxContainer/DiaryLabel

func _ready():
	display_stats()

func display_stats():
	var sg = SaveDataForPlayer.save_game

	pomodoros_label.text = "Pomodoros Completed: %d" % sg.total_time_pomodoros_completed
	studied_label.text = "Total Time Studied (seconds): %d" % sg.total_time_studied
	mood_label.text = "Mood: %s" % sg.mood
	diary_label.text = "Diary: %s" % sg.diary
