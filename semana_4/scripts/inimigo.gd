extends CharacterBody2D

@export var velocidade: float = 60

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var timer: Timer = %Timer
@onready var area_visao: Area2D = %VisaoInimigoArea
var jogador_na_area: bool = false
var jogador_ref: Player = null

@export var pontos_patrulha: Array[Node2D]
var indice_ponto_atual = -1

signal jogador_avistado()

func _ready():
	area_visao.body_entered.connect(_on_body_entered)
	area_visao.body_exited.connect(_on_body_exited)

# queremos saber quando o jogador estiver dentro do cone de visão
func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		jogador_na_area = true
		jogador_ref = body

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		jogador_na_area = false
		jogador_ref = null

func _physics_process(_delta):
	
	procurar_jogador()
	
	mover_patrulha()
	
	atualizar_animacoes()

func procurar_jogador():
	
	# Só prosseguimos se o jogador estiver dentro da área de detecção
	if not (jogador_na_area and jogador_ref != null):
		return
	
	# Apontamos o raio exatemente para o centro do jogador
	# Usamos to_local() porque a target_position do RayCast2D espera uma coordenada local
	$RayCast2D.target_position = to_local(jogador_ref.find_child("Shape").global_position)
	
	# Forçamos o raio a atualizar sua física neste exato frame
	$RayCast2D.force_raycast_update()
	
	# Verificamos em quem o raio bateu primeiro
	var objeto_atingido = $RayCast2D.get_collider()
	
	if objeto_atingido.is_in_group("player"):
		# O raio bateu no jogador! Emitimos o sinal para que a fase saiba que 
		# deve tomar atitude.
		jogador_avistado.emit()
	
	

func mover_patrulha():
	
	velocity = Vector2.ZERO
	
	# caso o timer esteja tocando, esperamos ele terminar primeiro.  
	if timer.time_left != 0:
		return
	
	if indice_ponto_atual == -1 and pontos_patrulha.size() > 0:
		indice_ponto_atual = 0
	
	# Pega a direção do inimigo até o ponto atual
	var direcao = global_position.direction_to(pontos_patrulha[indice_ponto_atual].global_position)
	velocity = direcao * velocidade
	
	# também rotacionamos a luz do inimigo para que ele olhe para onde 
	# está andando
	%Eixo.look_at(%Eixo.global_position + direcao)
	
	move_and_slide()
	
	# Se chegou muito perto do ponto, muda para o próximo ponto da lista
	if global_position.distance_to(pontos_patrulha[indice_ponto_atual].global_position) < 5:
		indice_ponto_atual += 1
		if indice_ponto_atual >= pontos_patrulha.size():
			indice_ponto_atual = 0
		
		# colocamos o inimigo para esperar um pouco antes de continuar usando 
		# um timer.
		timer.start()
	

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
	
	if velocity != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = velocity.normalized()
		animation_tree["parameters/Walk/blend_position"] = velocity.normalized()
