extends Area2D

var animacao: AnimationPlayer

signal botao_ativado(nome: String)

var ativado: bool = false 

# cada botão terá um nome customizado, que será usado na cena principal para 
# definir o que ele ativará.
@export var nome: String

func _ready():
	animacao = find_child("AnimationPlayer")
	body_entered.connect(ativar)

func ativar(body: Node2D):
	if ativado:
		return
	
	if not body.is_in_group("player"):
		return
	
	ativado = true
	
	# o jogador pisou no botão. vamos tocar a animação, esperar meio segundo e 
	# depois avisar ao jogo que o botão foi pressionado
	
	animacao.play("ativar")
	await animacao.animation_finished
	
	await get_tree().create_timer(0.5).timeout 
	
	botao_ativado.emit(nome)
