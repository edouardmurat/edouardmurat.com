extends Node2D

var deck
var discard
var play
var market
var ability

var ability_scene
var card_scene

func _on_SetupTimer2_timeout():
	deck = []
	discard = []
	play = [null, null, null]
	market = []
	ability = null
	
	ability_scene = load("res://Ability.tscn")
	card_scene = load("res://Card.tscn")
	build_deck()
	build_market()
	build_ability()
	enemy_turn()
	draw_card()
	draw_card()
	draw_card()
	update_board()

func build_ability():
	var global = get_node("/root/Global")
	add_ability(global.get_character().ability)
	

func build_deck():
	add_card("deck", "concentration", 20)
	add_card("deck", "concentration", 20)
	add_card("deck", "tranquility", 6)
	add_card("deck", "tranquility", 6)
	add_card("deck", "mindfulness", 2)
	add_card("deck", "mindfulness", 2)
	add_card("deck", "insight", 1)
	add_card("deck", "insight", 1)
	add_card("deck", "insight", 1)

func build_market():
	add_card("market", "concentration", 30)
	add_card("market", "tranquility", 10)
	add_card("market", "mindfulness", 4)

func draw_card():
	if play.count(null) > 0:
		# shuffle when no card left in deck
		if deck.size() == 0:
			shuffle_deck()
			yield(get_tree().create_timer(1), "timeout")
		var card = deck.pop_front()
		put_in_play(card)

func play_card(card):
	play[play.find(card)] = null
	put_in_discard(card)

func after_play_card():
	yield(get_tree().create_timer(1), "timeout")
	enemy_turn()
	yield(get_tree().create_timer(1), "timeout")
	draw_card()
	yield(get_tree().create_timer(1), "timeout")

func buy_card(card, insight_card):
	# use insight card
	play[play.find(insight_card)] = null
	destroy_card(insight_card)
	market.remove(market.find(card))
	card.flip_front()
	put_in_discard(card)
	yield(get_tree().create_timer(1), "timeout")
	update_market()
	yield(get_tree().create_timer(1), "timeout")
	enemy_turn()
	yield(get_tree().create_timer(1), "timeout")
	draw_card()
	yield(get_tree().create_timer(1), "timeout")

func enemy_turn():
	get_parent().get_node("Enemy").play()

func destroy_card(card):
	card.queue_free()

func shuffle_deck():
	for card in discard:
		if deck.empty():
			deck.insert(0, card)
		else:
			randomize()
			var i = randi() % (deck.size() + 1)
			deck.insert(i, card)
		card.flip_back()
	discard = []
	update_deck()
	update_discard()

func update_board():
	# update deck
	update_deck()
	
	# update discard
	update_discard()
	
	# update market
	update_market()
	
	# update play
	update_play()

func update_deck():
	for i in range(0, deck.size()):
		deck[i].is_draggable = false
		deck[i].move_to($Deck.position)
		deck[i].rotation = 0
		deck[i].z_index = 100 - i
	if deck.size() > 1:
		deck[0].deck()

func update_discard():
	for i in range(0, discard.size()):
		discard[i].is_draggable = false
		discard[i].move_to($Discard.position)
		discard[i].rotate(randf() / 8 - randf() / 8)
		discard[i].z_index = 100 - i

func update_market():
	for i in range(0, market.size()):
		market[i].is_draggable = false
		market[i].move_to($Market.position)
		market[i].z_index = 100 - i
		market[i].deck()
	if market.size() > 0:
		market[0].flip_front()

func update_play():
	for i in range(0, play.size()):
		if play[i] != null:
			play[i].is_draggable = true
			play[i].z_index = 101
			match i:
				0:
					play[i].move_to($Play1.position)
				1:
					play[i].move_to($Play2.position)
				2:
					play[i].move_to($Play3.position)
			
			play[i].rotate(randf() / 8 - randf() / 8)
			play[i].flip_front()
			play[i].glow_red()

func add_card(placement, type, value):
	var card = card_scene.instance()
	
	match placement:
		"deck":
			if deck.empty():
				deck.insert(0, card)
			else:
				randomize()
				var i = randi() % (deck.size() + 1)
				deck.insert(i, card)
			
			card.setup(type, value)
		"market":
			if market.empty():
				market.insert(0, card)
			else:
				randomize()
				var i = randi() % (market.size() + 1)
				market.insert(i, card)
			card.setup(type, value, true)
	
	add_child(card)

func put_in_play(card):
	play[play.find(null)] = card
	card.flip_front()
	update_play()
	update_deck()

func put_in_discard(card):
	discard.push_front(card)
	update_discard()
	update_play()
	update_deck()

func insight_card_accepted():
	market[0].glow_green()
func insight_card_selected():
	market[0].glow_orange()

func tranquility_card_accepted():
	get_parent().get_node("Player").glow_accepted()
func tranquility_card_selected():
	get_parent().get_node("Player").glow_selected()

func mindfulness_card_accepted():
	get_parent().get_node("Player").glow_accepted()
func mindfulness_card_selected():
	get_parent().get_node("Player").glow_selected()

func concentration_card_accepted():
	get_parent().get_node("Player").get_node("Bubble").glow_accepted()
func concentration_card_selected():
	get_parent().get_node("Player").get_node("Bubble").glow_selected()

func card_released():
	if market.size() > 0:
		market[0].no_glow()
	get_parent().get_node("Player").no_glow()
	get_parent().get_node("Player").get_node("Bubble").no_glow()

func add_ability(ability_info):
	ability = ability_scene.instance()
	add_child(ability)
	ability.setup(ability_info)
	ability.move_to($Ability.position)

func upgrade_defence_cards():
	var cards = deck + discard + play + market
	for card in cards:
		if card != null and card.type == "mindfulness":
			card.set_value(card.value + 1)

func upgrade_potion_cards():
	var cards = deck + discard + play + market
	for card in cards:
		if card != null and card.type == "tranquility":
			card.set_value(card.value + 1)

func upgrade_attack_cards():
	var cards = deck + discard + play + market
	for card in cards:
		if card != null and card.type == "concentration":
			card.set_value(card.value + 5)