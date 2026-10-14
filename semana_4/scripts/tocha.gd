extends Node2D


func _ready():
	var tween_energy = create_tween().set_loops()
	tween_energy.set_trans(Tween.TRANS_CUBIC)
	tween_energy.tween_property($PointLight2D, "energy", 1.5, 1.0)
	tween_energy.tween_property($PointLight2D, "energy", 1.8, 1.0)
	
	var tween_texture_scale = create_tween().set_loops()
	tween_texture_scale.set_trans(Tween.TRANS_CUBIC)
	tween_texture_scale.tween_property($PointLight2D, "texture_scale", 0.9, 1.0)
	tween_texture_scale.tween_property($PointLight2D, "texture_scale", 1.1, 1.0)
