extends Node2D

func play_music(name):
	match name:
		"menu":
			if not $MenuAudioStreamPlayer.playing:
				$GameAudioStreamPlayer.stop()
				$MenuAudioStreamPlayer.play()
		"game":
			if not $GameAudioStreamPlayer.playing:
				$MenuAudioStreamPlayer.stop()
				$GameAudioStreamPlayer.play()

func mute():
	$MenuAudioStreamPlayer.volume_db = -100
	$GameAudioStreamPlayer.volume_db = -100

func unmute():
	$MenuAudioStreamPlayer.volume_db = 0
	$GameAudioStreamPlayer.volume_db = 0