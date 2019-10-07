extends Node2D

const RED_OUTLINE_MATERIAL = preload("res://Shaders/RedOutlineMaterial.tres")
const ORANGE_OUTLINE_MATERIAL = preload("res://Shaders/OrangeOutlineMaterial.tres")
const GREEN_OUTLINE_MATERIAL = preload("res://Shaders/GreenOutlineMaterial.tres")

var global
var character
var can_be_touched = true

func setup(global, index, character):
	self.global = global
	self.character = character
	var j = index / 3
	var i = index % 3
	
	position.x += 150 + i * 200
	position.y += 500 + j * 280
	
	update()

func update():
	self.character = global.get_character_by_name(self.character.name)
	$CardAnimatedSprite/Name.text = Global.get_local(character.name)
	$CardAnimatedSprite/Descriiption.text = Global.get_local(character.ability.desc)
	$Price/Label.text = str(character.price)
	$CardAnimatedSprite.play("front")
	$CardAnimatedSprite/CharacterAnimatedSprite.play(self.character.name)
	
	if character.unlocked:
		$Price.visible = false
		$LockAnimatedSprite.visible = false
		$CardAnimatedSprite.modulate = Color(1, 1, 1)
	else:
		$Price.visible = true
		$LockAnimatedSprite.visible = true
		$CardAnimatedSprite.modulate = Color(0.5, 0.5, 0.5)
	
	if character.selected:
		glow_green()
	else:
		no_glow()

func unlock():
	character.unlocked = true
	global.set_character(character)
	update()

func select():
	character.selected = true
	global.set_character(character)
	var cards = get_tree().get_nodes_in_group("ShopCard")
	for card in cards:
		if card != self:
			card.unselect()
	update()

func unselect():
	character.selected = false
	global.set_character(character)
	update()

func no_glow():
	$CardAnimatedSprite.set_material(null)

func glow_green():
	if $CardAnimatedSprite.material != GREEN_OUTLINE_MATERIAL:
		$CardAnimatedSprite.set_material(GREEN_OUTLINE_MATERIAL)

func glow_orange():
	if $CardAnimatedSprite.material != ORANGE_OUTLINE_MATERIAL:
		$CardAnimatedSprite.set_material(ORANGE_OUTLINE_MATERIAL)

func glow_red():
	if $CardAnimatedSprite.material != RED_OUTLINE_MATERIAL:
		$CardAnimatedSprite.set_material(RED_OUTLINE_MATERIAL)

func _on_ShopCard_released():
	if not can_be_touched:
		return
	
	if character.unlocked:
		select()
	else:
		if global.save_var.money - character.price >= 0:
			get_parent().spend_money(character.price)
			unlock()
			select()
		else:
			$AnimationPlayer.play("cannot_buy")
			get_parent()._on_Buy_released()

func enable_touch():
	can_be_touched = true

func disable_touch():
	can_be_touched = false