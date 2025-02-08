extends Resource
class_name SaveGame

@export var default_work_minutes: int = 25
@export var default_rest_minutes: int = 5

@export var current_mode: String = "work"
@export var remaining_time: float = 0.0

@export var total_time_studied: int = 0
@export var total_time_pomodoros_completed: int = 0

@export var pause_count: int = 0
@export var mood: String = "Neutral"
@export var diary: String = ""

const SAVE_GAME_PATH = "res://save_game.tres"  # or "res://" for quick testing

func write_savegame():
	var err = ResourceSaver.save(self, SAVE_GAME_PATH)
	if err == OK:
		prints("SaveGame Resource saved to:", SAVE_GAME_PATH)
	else:
		push_error("Failed to save resource: " + str(err))

static func load_savegame() -> SaveGame:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		var loaded = ResourceLoader.load(SAVE_GAME_PATH)
		if loaded is SaveGame:
			prints("SaveGame Resource loaded from:", SAVE_GAME_PATH)
			return loaded
	return null
