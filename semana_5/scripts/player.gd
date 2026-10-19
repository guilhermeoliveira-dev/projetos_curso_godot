extends CharacterBody2D


@export var SPEED = 300.0
@export var forca_empurrao: float = 10

@onready var animation_tree: AnimationTree = $AnimationTree

var direcao: Vector2

func _physics_process(delta):
	
	# Para mais informações sobre controles, consulte a documentação:
	# https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
	
	direcao = Input.get_vector("mover_esquerda", "mover_direita", "mover_cima", "mover_baixo")
	
	# Se for teclado, precisamos normalizar para remover o bug da diagonal
	if Config.dispositivo == Config.TECLADO:
		direcao = direcao.normalized()
	
	velocity = direcao * SPEED
	
	move_and_slide()
	
	empurrar()
	
	atualizar_animacao()



func empurrar():
	
	# O loop que faz a mágica do empurrão acontecer
	for i in get_slide_collision_count():
		var colisao = get_slide_collision(i)
		var objeto_atingido = colisao.get_collider()
		
		# Se o objeto que batemos for afetado pela física (a porta)
		if objeto_atingido is RigidBody2D:
			# O get_normal() aponta para nós. Invertemos com o "-" para empurrar o objeto para longe
			var direcao_empurrao = -colisao.get_normal()
			
			# Aplica o solavanco no objeto
			objeto_atingido.apply_central_impulse(direcao_empurrao * forca_empurrao)

func atualizar_animacao():
	
	# mesmos esquemas de animação que vimos na aula da semana 4
	
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/esta_parado"] = true
		animation_tree["parameters/conditions/esta_andando"] = false
	else:
		animation_tree["parameters/conditions/esta_parado"] = false
		animation_tree["parameters/conditions/esta_andando"] = true
	
	if direcao != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = direcao
		animation_tree["parameters/Walk/blend_position"] = direcao
	


func _input(event):
	
	# Verificando qual o tipo de dispositivo o jogador está usando
	Config.atualizar_dispositivo(event)
	
	

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x,
		"pos_y" : position.y,
		"scale_x" : scale.x,
		"scale_y" : scale.y
	}
	return save_dict
