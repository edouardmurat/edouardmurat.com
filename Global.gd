extends Node

const SAVE_PATH = "user://savegame.data"

const dictionary = {
	"Play": ["Jouer"],
	"Shop": ["Magasin"],
	"Settings": ["Options"],
	"monk": ["moine"],
	"priest": ["pretre"],
	"pujari": ["pujari"],
	"imam": ["imame"],
	"rabbi": ["rabbin"],
	"granthi": ["granthi"],
	"music": ["musique"],
	"language": ["langue"],
	"max life +1": ["vie max +1"],
	"enemy attacks -1": ["attaques enemies -1"],
	"mindfulness +1": ["pleine conscience +1"],
	"tranquility +1": ["tranquilite +1"],
	"concentration +5": ["concentration +5"],
	"enemy life -10": ["vie enemie -10"],
	"insight": ["comprehension"],
	"mindfulness": ["pleine conscience"],
	"concentration": ["concentration"],
	"tranquility": ["tranquilite"],
	"attachment": ["attachement"],
	"pride": ["fierte"],
	"aversion": ["aversion"],
	"jealousy": ["jalousie"],
	"ignorance": ["ignorance"],
	"Ability:": ["Bonus:"],
	"Full unlock": ["Acces total"],
	"Enjoying EdNoKa?": ["Vous aimez EdNoKa?"],
	"Not really": ["Non"],
	"Yes!": ["Oui!"],
	"How about rating it, then?": ["Pourquoi pas le noter?"],
	"Care to give some feedback?": ["Vous voulez donner votre avis?"],
	"No, thanks": ["Non merci"],
	"Ok, sure": ["OK"],
}

var save_var = {
		"money": 0,
		"characters": [
			{"name": "monk", "price": 0, "unlocked": true, "selected": true, "ability": {
				"type": "more_player_life", "desc": "max life +1"}},
			{"name": "priest", "price": 23, "unlocked": false, "selected": false, "ability": {
				"type": "less_enemy_attack", "desc": "enemy attacks -1"}},
			{"name": "pujari", "price": 23, "unlocked": false, "selected": false, "ability": {
				"type": "more_player_def", "desc": "mindfulness +1"}},
			{"name": "imam", "price": 23, "unlocked": false, "selected": false, "ability": {
				"type": "more_player_heal", "desc": "tranquility +1"}},
			{"name": "rabbi", "price": 23, "unlocked": false, "selected": false, "ability": {
				"type": "more_player_attack", "desc": "concentration +5"}},
			{"name": "granthi", "price": 23, "unlocked": false, "selected": false, "ability": {
				"type": "less_enemy_life", "desc": "enemy life -10"}}
		],
		"music": true,
		"language": "en",
		"languages": ["en", "fr"],
		"time": null,
		"asked_opinion": false
	}

var music_scene
var music

func _ready():
	load_game()
	music_scene = load("res://Music.tscn")
	music = music_scene.instance()
	add_child(music)
	set_music(save_var.music)
	call_deferred("iap_setup")
	
	if save_var.time == null:
		save_var.time = OS.get_system_time_secs()
		save_game()

func iap_setup():
	IAP.set_auto_consume(false)
	#First listen to all callbacks
	IAP.connect("sku_details_complete",self,"on_sku_details_complete")
	IAP.connect("has_purchased",self,"on_iap_has_purchased")
	IAP.connect("purchase_success",self,"on_purchase_success_callback")
	IAP.connect("purchase_owned",self,"on_purchase_owned_callback")
	IAP.connect("consume_success",self,"on_consume_success")
	
	#Then ask google the details for these items
	IAP.sku_details_query(["ednoka_some_diamonds","ednoka_many_diamonds", "ednoka_full_unlock"])
	#Then ask google all purchased products
	IAP.request_purchased() #Ask Google for all purchased items

func on_sku_details_complete():
	print(IAP.sku_details) #This will print the details as JSON format, refer the format in iap.gd

func on_iap_has_purchased(item_name):
	print(item_name)
	if item_name == "ednoka_full_unlock":
		unlock_all()

func iap_buy_some_diamonds():
	IAP.purchase("ednoka_some_diamonds")

func iap_buy_many_diamonds():
	IAP.purchase("ednoka_many_diamonds")

func iap_full_unlock():
	IAP.purchase("ednoka_full_unlock")

#This function will be called when the purchase is a success
func on_purchase_success_callback(item):
	print(item + " has purchased")
	match item:
		"ednoka_some_diamonds": 
			IAP.consume("ednoka_some_diamonds")
			add_money(21)
			get_tree().change_scene("res://Shop.tscn")
		"ednoka_many_diamonds": 
			IAP.consume("ednoka_many_diamonds")
			add_money(47)
			get_tree().change_scene("res://Shop.tscn")
		"ednoka_full_unlock":
			unlock_all()
			get_tree().change_scene("res://Shop.tscn")

func on_consume_success(item):
    print(item + " consumed")

func load_game():
	var f = File.new()
	if f.file_exists(SAVE_PATH):
		f.open(SAVE_PATH, File.READ)
		save_var = f.get_var()
		f.close()
	else:
		save_game()

func save_game():
	var f = File.new()
	f.open(SAVE_PATH, File.WRITE)
	f.store_var(save_var)
	f.close()

func add_money(value):
	save_var.money += value
	save_game()

func spend_money(value):
	save_var.money -= value
	save_game()

func unlock_all():
	for character in save_var.characters:
		character.unlocked = true
	save_game()

func get_character():
	for character in save_var.characters:
		if character.selected:
			return character
	return null

func get_character_by_name(name):
	for character in save_var.characters:
		if character.name == name:
			return character
	return null

func set_character(character):
	for i in range(0, save_var.characters.size()):
		if save_var.characters[i].name == character.name:
			save_var.characters[i] = character
	save_game()

func set_music(b):
	save_var.music = b
	if save_var.music == false:
		music.mute()
	else:
		music.unmute()
	save_game()

func set_next_language():
	var i = (save_var.languages.find(save_var.language) + 1)%save_var.languages.size()
	save_var.language = save_var.languages[i]
	save_game()

func get_local(text):
	match save_var.language:
		"en":
			return text
		"fr":
			return dictionary.get(text)[0]

func play_music(name):
	music.play_music(name)

func has_been_asked_opinion():
	return save_var.asked_opinion

func opninion_asked():
	save_var.asked_opinion = true
	save_game()

func elapsed_time_since_first_run():
	return OS.get_system_time_secs() - Global.save_var.time