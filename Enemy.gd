extends Node2D

var cards = [
	{"name": "attachment", "health": 30, "attack": 4},
	{"name": "pride", "health": 20, "attack": 6},
	{"name": "aversion", "health": 50, "attack": 3},
	{"name": "jealousy", "health": 30, "attack": 4},
	{"name": "ignorance", "health": 50, "attack": 3},
]

var enemy_index = 0
var enemy_size = cards.size()

var card
var has_appeared = true

# Called when the node enters the scene tree for the first time.
func _ready():
	shuffle()
	next_card()
	hide_all()

func shuffle():
	var shuffledCards = []
	var indexList = range(cards.size())
	for i in range(cards.size()):
		randomize()
		var x = randi()%indexList.size()
		shuffledCards.append(cards[x])
		indexList.remove(x)
		cards.remove(x)
	
	cards = shuffledCards

func play():
	if not has_appeared:
		$AttackLabel.add_color_override("font_color", Color(1,0,0))
		get_parent().get_node("Player").is_hit_by(card.attack)
		yield(get_tree().create_timer(0.5 * int($AttackLabel.text)), "timeout")
		$AttackLabel.add_color_override("font_color", Color(0,0,0))
	else :
		has_appeared = false

func next_card():
	if cards.empty():
		get_parent().win()
	else:
		enemy_index += 1
		$IndexLabel.text = str(enemy_index) + "/" + str(enemy_size)
		show_all()
		card = cards.pop_front()
		$AnimatedSprite.play(card.name)
		$NameLabel.text = Global.get_local(card.name).capitalize()
		$HealthLabel.text = str(card.health)
		$AttackLabel.text = str(card.attack)

func is_hit_by(points):
	$IsHitAnimatedSprite.visible = true
	$IsHitAnimatedSprite.play("is_hit")
	$HealthLabel.add_color_override("font_color", Color(1,0,0))
	$HealthLabel.text = str(int($HealthLabel.text) - points)
	yield(get_tree().create_timer(0.5), "timeout")
	
	$HealthLabel.add_color_override("font_color", Color(0,0,0))
	if int($HealthLabel.text) <= 0:
		has_appeared = true
		hide_all()
		get_parent().get_node("Player/Bubble").die()
		yield(get_tree().create_timer(1), "timeout")
		get_parent().get_node("Player/Bubble").visible = false
		if not cards.empty():
			get_parent().get_node("Player/Bubble").visible = true
			get_parent().get_node("Player/Bubble").think()
			yield(get_tree().create_timer(1.2), "timeout")
		next_card()

func _on_IsHitAnimatedSprite_animation_finished():
	$IsHitAnimatedSprite.visible = false
	$IsHitAnimatedSprite.frame = 0

func reduce_enemies_attack():
	#modify current enemy
	card.attack -= 1
	$AttackLabel.text = str(card.attack)
	
	#modify enemies left
	for enemy in cards:
		enemy.attack -= 1

func reduce_enemies_life():
	#modify current enemy
	card.health -= 10
	$HealthLabel.text = str(card.health)
	
	#modify enemies left
	for enemy in cards:
		enemy.health -= 10

func show_all():
	visible = true

func hide_all():
	visible = false
