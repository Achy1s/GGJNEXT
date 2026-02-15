extends Button

func _ready():
	# Buton tıklandığında GameManager'daki fonksiyonu çalıştır
	pressed.connect(_on_self_pressed)

func _on_self_pressed():
	GameManager.start_double_score_buff()
