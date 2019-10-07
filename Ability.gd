extends Node2D

var info

func setup(info):
	self.info = info
	$TitleLabel.text = Global.get_local("Ability:")
	$DescriptionLabel.text = Global.get_local(info.desc)
	z_index = 200
	
	match info.type:
		"more_player_life":
			get_parent().get_parent().get_node("Player").get_node("Health").increase_max_health()
		"less_enemy_attack":
			get_parent().get_parent().get_node("Enemy").reduce_enemies_attack()
		"more_player_def":
			get_parent().upgrade_defence_cards()
		"more_player_heal":
			get_parent().upgrade_potion_cards()
		"more_player_attack":
			get_parent().upgrade_attack_cards()
		"less_enemy_life":
			get_parent().get_parent().get_node("Enemy").reduce_enemies_life()

func move_to(new_pos):
	$Tween.interpolate_property(
		self, "position", 
		position, new_pos, 0.5,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()