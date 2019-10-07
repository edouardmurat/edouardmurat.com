extends Node2D

signal done

func _ready():
	z_index = 500

func lose():
	$AnimationPlayer.play("lose")
	
func win():
	$AnimationPlayer.play("win")

func _on_WatchAd_released():
	AdMob.show_rewarded()
	emit_signal("done")

func _on_Restart_released():
	emit_signal("done")

func _input(event):
	get_tree().set_input_as_handled()