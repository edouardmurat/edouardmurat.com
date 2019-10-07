extends Node2D

var store_opened = false
var global
var shopcard_scene
var shopcards

func _ready():
	global = get_node("/root/Global")
	$SlidingTitle/Label.text = Global.get_local("Shop")
	$MyMoney/Label.text = str(global.save_var.money)
	$Store.visible = false
	$Store/FullUnlockButton/Label.text = global.get_local("Full unlock")

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		get_tree().change_scene("res://Menu.tscn")
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().change_scene("res://Menu.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Menu.tscn")

func _on_Timer_timeout():
	shopcards = global.save_var.characters
	shopcard_scene = load("res://ShopCard.tscn")
	
	for i in range(0, shopcards.size()):
		var card = shopcards[i]
		var shopcard = shopcard_scene.instance()
		shopcard.setup(global, i, card)
		add_child(shopcard)

func spend_money(value):
	global.spend_money(value)
	$MyMoney/Label.text = str(global.save_var.money)

func _on_Back_released():
	get_tree().change_scene("res://Menu.tscn")

func _on_Buy_released():
	$Store/SomeDIamondsButton/PriceLabel.text = IAP.sku_details["ednoka_some_diamonds"].price
	$Store/ManyDiamondsButton/PriceLabel.text = IAP.sku_details["ednoka_many_diamonds"].price
	$Store/FullUnlockButton/PriceLabel.text = IAP.sku_details["ednoka_full_unlock"].price
	$Store.z_index = 600
	$Store.visible = true
	disable_all_shop_cards()

func _on_StoreBack_released():
	$Store.visible = false
	enble_all_shop_cards()

func enble_all_shop_cards():
	var shopcards = get_tree().get_nodes_in_group("ShopCard")
	for shopcard in shopcards:
		shopcard.enable_touch()

func disable_all_shop_cards():
	var shopcards = get_tree().get_nodes_in_group("ShopCard")
	for shopcard in shopcards:
		shopcard.disable_touch()

func _on_SomeDIamondsButton_pressed():
	global.iap_buy_some_diamonds()

func _on_ManyDiamondsButton_pressed():
	global.iap_buy_many_diamonds()

func _on_FullUnlockButton_pressed():
	global.iap_full_unlock()
