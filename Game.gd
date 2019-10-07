extends Node2D

var slidingresult_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Health.visible = false
	$Player/Bubble.visible = false
	slidingresult_scene = load("res://SlidingResult.tscn")
	Global.play_music("game")

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene("res://Menu.tscn")
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().change_scene("res://Menu.tscn")
		

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")

func win():
	var slidingresult = slidingresult_scene.instance()
	add_child(slidingresult)
	slidingresult.connect("done", self, "restart")
	slidingresult.win()
	Global.add_money(1)

func lose():
	var slidingresult = slidingresult_scene.instance()
	add_child(slidingresult)
	slidingresult.connect("done", self, "restart")
	slidingresult.lose()

func restart():
	get_tree().change_scene("res://Game.tscn")

func _on_SetupTimer_timeout():
	$Player/Health.visible = true
	$Player/Bubble.visible = true
	$Player/Bubble/AnimationPlayer.play("think")
	$SetupTimer2.start()

func _on_SetupTimer2_timeout():
	$Enemy.show_all()

func _on_TouchScreenButton_released():
	get_tree().change_scene("res://Menu.tscn")
