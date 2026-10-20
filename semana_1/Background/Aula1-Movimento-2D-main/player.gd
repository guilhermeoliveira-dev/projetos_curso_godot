extends CharacterBody2D

# Definimos algumas variáveis para regular como o nosso personagem se movimenta.

var GRAVIDADE: float = 8
var VELOCIDADE: float = 150
var PULO: float = 300

var pontos: int = 0

func _physics_process(_delta):
	
	var input_horizontal: float = 0
	
	# Forma n.1 de captar inputs: Input.is_action (ou is_action_pressed)
	# Dessa forma, podemos verificar em outras funções se o botão foi pressionado.
	# Nesse caso, é útil ser feita dentro do _physics_process pois usamos isso diretamente para mover o personagem.
	if Input.is_action_pressed("ui_left"):
		input_horizontal -= VELOCIDADE
	if Input.is_action_pressed("ui_right"):
		input_horizontal += VELOCIDADE
	
	velocity.x = input_horizontal
	
	if not is_on_floor():
		velocity.y += GRAVIDADE
	
	move_and_slide()
	

# Forma n.2 de captar inputs: função _input. 
# Esta função é chamada sempre que um botão é pressionado.
# Nesse caso, é mais simples que o pulo seja feito aqui.
func _input(event):
	
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = -PULO
			pontos = pontos + 1
			%Pontos.text = str(pontos)
	
	# Aplicação do método n.1 para detectar inputs:
	# Essa forma perde um pouco de valor pois não temos como controlar facilmente quando aceleramos 
	# e quando paramos, bem como se estamos indo para os dois lados ao mesmo tempo. 
	#if event.is_action("ui_left"):
		#velocity.x = -VELOCIDADE
	#if event.is_action("ui_right"):
		#velocity.x = VELOCIDADE
