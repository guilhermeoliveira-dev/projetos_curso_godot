extends Button

func _ready():
	pressed.connect(Config.save_game)
