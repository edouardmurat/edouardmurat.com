extends Node2D

func _input(event):
	if visible:
		self.get_tree().set_input_as_handled()