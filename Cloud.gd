extends Node2D

func _ready():
	z_index = -9
	position.x = 900
	position.y = randi() % 900 + 150
	var new_scale = randf() + 0.2
	scale.x = new_scale
	scale.y = new_scale
	var new_pos = position
	new_pos.x = -500
	
	$Tween.interpolate_property(
	self, "position", 
	position, new_pos, randi() % 10 + 15,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func _process(delta):
	if position.x < -250:
		queue_free()