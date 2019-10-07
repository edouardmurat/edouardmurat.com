extends Node2D

var global
var music

func _ready():
	global = get_node("/root/Global")
	setup_labels()
	set_music(global.save_var.music)
	$LanguageTouchScreenButton/Label.text = global.save_var.language

func setup_labels():
	$SlidingTitle/Label.text = Global.get_local("Settings")
	$MusicLabel.text = Global.get_local("music")
	$LanguageLabel.text = Global.get_local("language")

func set_music(b):
	if b:
		$MusicTouchScreenButton/AnimatedSprite.play("checked")
	else:
		$MusicTouchScreenButton/AnimatedSprite.play("unchecked")
	music = b
	global.set_music(music)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene("res://Menu.tscn")
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().change_scene("res://Menu.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")

func _on_TouchScreenButton_released():
	get_tree().change_scene("res://Menu.tscn")

func _on_MusicTouchScreenButton_pressed():
	set_music(!music)

func _on_LanguageTouchScreenButton_pressed():
	global.set_next_language()
	$LanguageTouchScreenButton/Label.text = global.save_var.language
	setup_labels()
