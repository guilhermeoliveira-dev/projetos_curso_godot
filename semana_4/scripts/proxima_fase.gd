extends Area2D

signal fim_de_fase()

func _ready():
	body_entered.connect(win)
	

func win(body: Node2D):
	if not body.is_in_group("player"):
		return
	
	fim_de_fase.emit()
