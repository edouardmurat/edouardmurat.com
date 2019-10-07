extends Node2D

signal done

const SHIELD_MATERIAL = preload("res://Shaders/ShieldMaterial.tres")
const ORANGE_OUTLINE_MATERIAL = preload("res://Shaders/OrangeOutlineMaterial.tres")
const GREEN_OUTLINE_MATERIAL = preload("res://Shaders/GreenOutlineMaterial.tres")

var protection = 0
var is_shaking = false
var shake_amount = 10.0

func _process(delta):
	if is_shaking:
		$AnimatedSprite.offset = Vector2( rand_range(-1.0, 1.0) * shake_amount, 
		rand_range(-1.0, 1.0) * shake_amount )

func is_protected_by(points):
	protection = points
#	glow_shield()

func is_healed_by(points):
	$Health.add_health(points)
	yield($Health, "done")
	emit_signal("done")

func is_hit_by(points):
	$Bubble.attack(points)
	points -= protection
	protection = 0
	if points > 0:
		shake()
		$Health.add_health(-points)

func shake():
	is_shaking = true
	var timer = Timer.new()
	yield(get_tree().create_timer(0.5), "timeout")
	stop_shaking()

func stop_shaking():
	is_shaking = false
	no_glow()

func no_glow():
	$AnimatedSprite.set_material(null)

func glow_accepted():
	if $AnimatedSprite.material != GREEN_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(GREEN_OUTLINE_MATERIAL)

func glow_selected():
	if $AnimatedSprite.material != ORANGE_OUTLINE_MATERIAL:
		$AnimatedSprite.set_material(ORANGE_OUTLINE_MATERIAL)

func glow_shield():
	if $AnimatedSprite.material != SHIELD_MATERIAL:
		$AnimatedSprite.set_material(SHIELD_MATERIAL)
	