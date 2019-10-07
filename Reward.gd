extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 1000
	$AnimationPlayer.play("slide")
	Global.add_money(2)

func stop():
	queue_free()