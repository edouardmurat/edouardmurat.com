extends Node2D

var cloud_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	cloud_scene = load("res://Cloud.tscn")
	_on_CloudTimer_timeout()

func _on_CloudTimer_timeout():
	var cloud = cloud_scene.instance()
	add_child(cloud)
