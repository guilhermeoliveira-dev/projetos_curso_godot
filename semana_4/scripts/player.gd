extends CharacterBody2D
class_name Player

@export var velocidade: float = 150.0

@onready var animation_tree: AnimationTree = %AnimationTree

var direcao: Vector2

const ORIGEM_TOCHA: Vector2 = Vector2(0, -4)
var tocha_acesa: bool = true

func _ready():
	animation_tree.active = true
	animation_tree["parameters/Idle/blend_position"] = Vector2.DOWN

func _physics_process(_delta):
	
	direcao = Input.get_vector("andar_esquerda", "andar_direita", "andar_cima", "andar_baixo")
	direcao = direcao.normalized()
	
	if direcao:
		velocity = direcao * velocidade
		%Tocha.position = ORIGEM_TOCHA + direcao * 6
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	atualizar_animacoes()

func atualizar_animacoes():
	# aqui atualizamos as variáveis que configuramos no animation tree 
	# para controlar as animações, não escolhemos manualmente as animações
	
	if velocity == Vector2.ZERO:
		# jogador parado, vamos colocá-lo em idle
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		# jogador se mechendo, vamos colocá-lo para se mover
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
	
	if direcao != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direcao
		animation_tree["parameters/Walk/blend_position"] = direcao
	

func _input(event):
	
	
	# alternamos se a tocha está acesa ou apagada e armazenamos o valor 
	if event.is_action_pressed("usar_tocha"):
		if tocha_acesa:
			tocha_acesa = false
			%Tocha.visible = false
			%SomTocha.stop()
		else:
			tocha_acesa = true
			%Tocha.visible = true
			%SomTocha.play()
