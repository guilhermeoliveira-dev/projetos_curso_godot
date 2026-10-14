extends StaticBody2D


var animacao: AnimationPlayer

func ativar():
	animacao.play("porta/abrir")
	

func _ready():
	animacao = find_child("AnimationPlayer")
