@tool
extends Sprite2D

var luz: PointLight2D

#var movimento: float
@export var velocidade: float = 0.5
@export var distancia: float = 20

var timer: float = 0

func _ready():
	luz = find_child("PointLight2D")

func _process(delta):
	timer += delta
	
	frame = abs((int) (timer * velocidade) % 4)
	
	if luz:
		# Colocar a luz para orbitar em volta do personagem
		luz.rotation = timer * velocidade - deg_to_rad(90)
		luz.position = Vector2(cos(timer * velocidade) * distancia, sin(timer * velocidade) * distancia)
	
