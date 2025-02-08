extends Node

var save_game: SaveGame

func _ready():
	save_game = SaveGame.load_savegame()
	if save_game == null:
		save_game = SaveGame.new()
		save_game.write_savegame()  # Write an initial file so next time it is found
