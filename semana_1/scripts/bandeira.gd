extends Area2D




func _on_body_entered(body: Node2D):
	
	# Só desejamos verificar a colisão do jogador, nada mais.
	if not body.is_in_group("player"):
		return
	
	# Desativamos o jogador para que não se mova após o fim do jogo.
	body.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Exibimos a mensagem de fim de jogo, tornando o canvas layer que a contém visível.
	%"Fim de Jogo".show()
