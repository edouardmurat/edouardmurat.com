extends Node2D

signal done

var global
var max_health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	global = get_node("/root/Global")
	var character = global.get_character()
	get_parent().get_node("AnimatedSprite").play(character.name + "_" + "full")
	$Label.text = str(max_health)

func increase_max_health():
	max_health = 11
	$Label.text = str(max_health)

func add_health(points):
	if points > 0:
		$Label.add_color_override("font_color", Color(0,1,0))
		var new_health = int($Label.text) + abs(points)
		if new_health > max_health:
			new_health = max_health
		$Label.text = str(new_health)
		change_player_face_according_to_health()
		yield(get_tree().create_timer(0.5), "timeout")
	elif points < 0:
		$Label.add_color_override("font_color", Color(1,0,0))
		var new_health = int($Label.text) - abs(points)
		if new_health > 0:
			$Label.text = str(new_health)
			change_player_face_according_to_health()
			yield(get_tree().create_timer(0.5), "timeout")
		else:
			$Label.text = "0"
			get_parent().get_parent().lose()
	
	$Label.add_color_override("font_color", Color(1,1,1))
	emit_signal("done")

func change_player_face_according_to_health():
	var character = global.get_character()
	var value = int($Label.text)
	if value <= 2:
		get_parent().get_node("AnimatedSprite").play(character.name + "_" + "very_low")
		get_parent().get_node("AnimatedSprite").modulate = Color(1,0.7,0.7)
	elif value <= 4 :
		get_parent().get_node("AnimatedSprite").play(character.name + "_" + "low")
		get_parent().get_node("AnimatedSprite").modulate = Color(1,0.8,0.8)
	elif value <= 7 :
		get_parent().get_node("AnimatedSprite").play(character.name + "_" + "mid")
		get_parent().get_node("AnimatedSprite").modulate = Color(1,0.9,0.9)
	elif value <= max_health :
		get_parent().get_node("AnimatedSprite").play(character.name + "_" + "full")
		get_parent().get_node("AnimatedSprite").modulate = Color(1,1,1)