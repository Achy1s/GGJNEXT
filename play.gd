extends Button

func _ready():
	pressed.connect(_on_self_pressed)

func _on_self_pressed():
	get_tree().change_scene_to_file("res://game_scene.tscn")
