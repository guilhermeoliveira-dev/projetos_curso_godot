extends Control



func _ready():
	find_child("NewGame").pressed.connect(find_parent("SceneHandler")._on_new_game_pressed)
	find_child("Quit").pressed.connect(find_parent("SceneHandler")._on_quit_pressed)
