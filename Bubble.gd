extends Node2D

const RED_OUTLINE_MATERIAL = preload("res://Shaders/RedOutlineMaterial.tres")
const ORANGE_OUTLINE_MATERIAL = preload("res://Shaders/OrangeOutlineMaterial.tres")
const GREEN_OUTLINE_MATERIAL = preload("res://Shaders/GreenOutlineMaterial.tres")

func no_glow():
	$AnimatedSprite.set_material(null)

func glow_accepted():
	if $AnimatedSprite.material != GREEN_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(GREEN_OUTLINE_MATERIAL)

func glow_selected():
	if $AnimatedSprite.material != ORANGE_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(ORANGE_OUTLINE_MATERIAL)

func glow_attack():
	if $AnimatedSprite.material != RED_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(RED_OUTLINE_MATERIAL)

func attack(points):
	glow_attack()
	yield(get_tree().create_timer(0.5 * abs(points)), "timeout")
	no_glow()

func think():
	$AnimationPlayer.play("think")

func die():
	$AnimationPlayer.play("die")