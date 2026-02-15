extends Control

func _on_play_button_pressed():
	# Oyunun asıl sahnesinin yolunu buraya yazmalısın
	get_tree().change_scene_to_file("res://game.tscn")

func _on_quit_button_pressed():
	# Oyunu kapatır
	get_tree().quit()
