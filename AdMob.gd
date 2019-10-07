extends Node
var admob = null
var isReal = true
var isForChildDirectedTreatment = false
var maxAdContentRating = "PG"
var isTop = false
var rewardScene
var isRewarded = false

#var adBannerId = "ca-app-pub-3940256099942544/6300978111" # Test ID
#var adRewardedId = "ca-app-pub-3940256099942544/5224354917" # Test ID
var adBannerId = "ca-app-pub-3142327628655082/5693546743"
var adRewardedId = "ca-app-pub-3142327628655082/8051637842"


func _ready():
	call_deferred("_init_ads")

func _init_ads():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		var res = admob.initWithContentRating(isReal, get_instance_id(), isForChildDirectedTreatment, maxAdContentRating)
		admob.resize()
		admob.loadBanner(adBannerId, isTop)
		admob.showBanner()
		admob.resize()
		admob.loadRewardedVideo(adRewardedId)
		rewardScene = load("res://Reward.tscn")

func show_rewarded():
	admob.showRewardedVideo()

# Callback for rewarded video ad closed 
func _on_rewarded_video_ad_closed():
	var reward = rewardScene.instance()
	add_child(reward)
	isRewarded = false

# Callback for rewarded video ad reward user
# @param String currency The reward item description, ex: coin
# @param int amount The reward item amount
func _on_rewarded(currency, amount):
	isRewarded = true

# Callback for rewarded video ad failed to load
# @param int errorCode the code of error
#_on_rewarded_video_ad_failed_to_load(errorCode)