extends CharacterBody2D

# Referência ao sprite do jogador, para atualizar a animação
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Constantes que alteram a movimentação do jogador (ver código abaixo)
const VELOCIDADE = 300.0
const PULO: float = 550.0

# Pontuação que atualiza a cada item coletado (ver script da fruta)
var pontos: int = 0

func _physics_process(delta: float) -> void:
	# Aplicar gravidade caso o jogador não esteja no chão
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Forma n.1 de captar inputs: dentro do método process usando a classe  
	# Input, usamos esse valor aqui mesmo durante o processo de cada tick do 
	# jogador.
	
	# Aqui usamos o método get_axis, pois ele 
	# condensa os dois botões (esquerda e direita) em um único número, sendo
	# negativo para esquerda e positivo para a direita. 
	var direction := Input.get_axis("mover_esquerda", "mover_direita")
	if direction != 0:
		velocity.x = direction * VELOCIDADE
	else:
		velocity.x = 0
	move_and_slide()
	
	# Ajustar animação
	if velocity.x >1 or velocity.x <-1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
	
	# Garantir que o sprite esteja orientado corretamente
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true



# Forma n.2 de captar inputs: função _input. 
# Esta função é chamada sempre que um botão é pressionado.
# Nesse caso, é mais simples que o pulo seja feito aqui.
func _input(event):
	
	if event.is_action_pressed("pular"):
		if is_on_floor():
			velocity.y = -PULO
	

# É chamado pelas frutas quando elas detectam colisão com o jogador
func aumentar_pontos():
	pontos = pontos + 1
	%Pontos.text = "Pontos: "+str(pontos)
