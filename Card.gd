extends TouchScreenButton

const RED_OUTLINE_MATERIAL = preload("res://Shaders/RedOutlineMaterial.tres")
const ORANGE_OUTLINE_MATERIAL = preload("res://Shaders/OrangeOutlineMaterial.tres")
const GREEN_OUTLINE_MATERIAL = preload("res://Shaders/GreenOutlineMaterial.tres")

var type
var value
var is_special
var is_draggable

var dragging = false
var old_position
var offset
var animation_name

func setup(setup_type, setup_value, setup_is_special = false):
	type = setup_type
	value = setup_value
	is_special = setup_is_special
	
	animation_name = setup_type
	if is_special:
		animation_name += "-special"
	
	$TypeLabel.text = Global.get_local(type)
	$ValueLabel.text = str(value)
	match type:
		"mindfulness":
			$AnimatedSprite2.play("shield")
		"concentration":
			$AnimatedSprite2.play("sword")
		"tranquility":
			$AnimatedSprite2.play("potion")
		"insight":
			$AnimatedSprite2.play("money")
	
	flip_back()

func set_value(new_value):
	value = new_value
	$ValueLabel.text = str(value)

func deck():
	$AnimatedSprite.play("deck")
	$AnimatedSprite2.hide()
	$ValueLabel.hide()
	$TypeLabel.hide()

func flip_back():
	$AnimatedSprite.play("back")
	$AnimatedSprite2.hide()
	$ValueLabel.hide()
	$TypeLabel.hide()

func flip_front():
	if $AnimatedSprite.animation != "front":
		$AnimationPlayer.play("flip_front")

func _process(delta):
	if dragging:
		position = get_viewport().get_mouse_position() - offset
		if "insight" in type:
			if is_over_market():
				glow_accepted()
			else:
				glow_selected()
		elif "concentration" in type:
			if is_over_enemy():
				glow_accepted()
			else:
				glow_selected()
		elif "mindfulness" in type:
			if is_over_player():
				glow_accepted()
			else:
				glow_selected()
		elif "tranquility" in type:
			if is_over_player():
				glow_accepted()
			else:
				glow_selected()

func _on_Card_pressed():
	if is_draggable:
		old_position = position
		offset = get_viewport().get_mouse_position() - position
		dragging = true

func _on_Card_released():
	if is_draggable:
		no_glow()
		dragging = false
		get_parent().card_released()
		
		if "insight" in type and is_over_market():
			get_parent().buy_card(get_parent().market[0], self)
		elif "concentration" in type and is_over_enemy():
			get_parent().get_parent().get_node("Enemy").is_hit_by(value)
			get_parent().play_card(self)
			get_parent().after_play_card()
		elif "mindfulness" in type and is_over_player():
			get_parent().get_parent().get_node("Player").is_protected_by(value)
			get_parent().play_card(self)
			get_parent().after_play_card()
		elif "tranquility" in type and is_over_player():
			get_parent().get_parent().get_node("Player").is_healed_by(value)
			get_parent().play_card(self)
			yield(get_parent().get_parent().get_node("Player"), "done")
			get_parent().after_play_card()
		else:
			glow_red()
			position = old_position

func is_over_enemy():
	var enemy = get_parent().get_parent().get_node("Enemy")
	return global_position.distance_to(enemy.global_position) < 100

func is_over_market():
	var market = get_parent().get_node("Market")
	return global_position.distance_to(market.global_position) < 50

func is_over_player():
	var player = get_parent().get_parent().get_node("Player")
	return global_position.distance_to(player.global_position) < 50


func no_glow():
	$AnimatedSprite.set_material(null)

func glow_accepted():
	if $AnimatedSprite.material != GREEN_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(GREEN_OUTLINE_MATERIAL)
	
	if "insight" in type:
		get_parent().insight_card_accepted()
	elif "tranquility" in type:
		get_parent().tranquility_card_accepted()
	elif "mindfulness" in type:
		get_parent().mindfulness_card_accepted()
	elif "concentration" in type:
		get_parent().concentration_card_accepted()

func glow_selected():
	if $AnimatedSprite.material != ORANGE_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(ORANGE_OUTLINE_MATERIAL)
	
	if "insight" in type:
		get_parent().insight_card_selected()
	elif "tranquility" in type:
		get_parent().tranquility_card_selected()
	elif "mindfulness" in type:
		get_parent().mindfulness_card_selected()
	elif "concentration" in type:
		get_parent().concentration_card_selected()

func glow_green():
	if $AnimatedSprite.material != GREEN_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(GREEN_OUTLINE_MATERIAL)

func glow_orange():
	if $AnimatedSprite.material != ORANGE_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(ORANGE_OUTLINE_MATERIAL)

func glow_red():
	if $AnimatedSprite.material != RED_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(RED_OUTLINE_MATERIAL)

func move_to(new_pos):
	$Tween.interpolate_property(
		self, "position", 
		position, new_pos, 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()