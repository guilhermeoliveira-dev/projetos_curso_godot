extends Node2D

func _ready():
	
	# vamos conectar os botões para que eles sejam lidos.
	for botao in get_tree().get_nodes_in_group("botao"):
		botao.botao_ativado.connect(botao_pressionado)
	
	# vamos conectar os inimigos para que eles possam avisar quando 
	# detectarem o jogador.
	for inimigo in get_tree().get_nodes_in_group("inimigo"):
		inimigo.jogador_avistado.connect(game_over)
	

func _on_tile_map_child_entered_tree(node):
	# vamos conectar os gatilhos de fim de fase para que o jogo termine 
	# quando eles forem tocados.
	if node.is_in_group("fim_de_fase"):
		node.fim_de_fase.connect(win)

func botao_pressionado(nome):
	
	# um botão foi pressionado, vamos ativar os itens correspondentes.
	
	for item in get_tree().get_nodes_in_group(nome):
		if item.has_method("ativar"):
			item.ativar()

func game_over():
	get_tree().reload_current_scene()
	pass

func win():
	%TelaVitoria.visible = true
	pass
