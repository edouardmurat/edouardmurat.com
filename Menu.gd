extends Node2D

var loading
var enjoying = null
var rating = null
var feedback = null

func _ready():
	loading = load("res://Loading.tscn").instance()
	loading.hide()
	add_child(loading)
	$SlidingTitle/Label.text = "EdNoKa"
	$PlayTouchScreenButton/Label.text = Global.get_local("Play")
	$ShopTouchScreenButton/Label.text = Global.get_local("Shop")
	$SettingsTouchScreenButton/Label.text = Global.get_local("Settings")
	Global.play_music("menu")
	
	# 90000 sec == 1 day
	if (Global.elapsed_time_since_first_run() > 90000) and not Global.has_been_asked_opinion():
		ask_enjoying()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().quit()
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_PlayTouchScreenButton_released():
	loading.show()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Game.tscn")

func _on_ShopTouchScreenButton_released():
	get_tree().change_scene("res://Shop.tscn")

func _on_SettingsTouchScreenButton_released():
	get_tree().change_scene("res://Settings.tscn")

# Ask questions

func ask_enjoying():
	$Question/Label.text = Global.get_local("Enjoying EdNoKa?")
	$Question/NoTouchScreenButton/Label.text = Global.get_local("Not really")
	$Question/YesTouchScreenButton/Label.text = Global.get_local("Yes!")
	$AnimationPlayer.play("slide_question")

func ask_rating():
	$Question/Label.text = Global.get_local("How about rating it, then?")
	$Question/NoTouchScreenButton/Label.text = Global.get_local("No, thanks")
	$Question/YesTouchScreenButton/Label.text = Global.get_local("Ok, sure")
	$AnimationPlayer.play("slide_question")

func ask_feedback():
	$Question/Label.text = Global.get_local("Care to give some feedback?")
	$Question/NoTouchScreenButton/Label.text = Global.get_local("No, thanks")
	$Question/YesTouchScreenButton/Label.text = Global.get_local("Ok, sure")
	$AnimationPlayer.play("slide_question")
 
func _on_NoTouchScreenButton_released():
	if enjoying == null:
		print("N1")
		enjoying = false
		$AnimationPlayer.stop()
		ask_feedback()
	elif enjoying:
		print("N2")
		rating = false
		Global.opninion_asked()
		$Question.queue_free()
	else:
		print("N3")
		feedback = false
		Global.opninion_asked()
		$Question.queue_free()

func _on_YesTouchScreenButton_released():
	if enjoying == null:
		print("Y1")
		enjoying = true
		$AnimationPlayer.stop()
		ask_rating()
	elif enjoying:
		print("Y2")
		rating = true
		Global.opninion_asked()
		$Question.queue_free()
		OS.shell_open("https://play.google.com/store/apps/details?id=com.edouardmurat.ednoka")
	else:
		print("Y3")
		feedback = true
		Global.opninion_asked()
		$Question.queue_free()
		if Global.save_var.language == "en":
			OS.shell_open("mailto:edouardmurat1@gmail.com?subject=EdNoka%20Feedback&body=%2AYour%20feedback%20here%2A")
		else:
			OS.shell_open("mailto:edouardmurat1@gmail.com?subject=EdNoka%20Opinion&body=%2AVotre%20opinion%20ici%2A")
			