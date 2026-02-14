extends Area2D

var timer: Timer
var level: int = 0 
var point: int = 0
var max_level: int = 3

func get_level_up_cost() -> int:
	if level == 0:
		return 75
	return 50 * level

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 7.5
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	
	if level == 0:
		modulate = Color(0.3, 0.3, 0.3, 0.8)
		print("Patates kilitli! Açmak için sağ tıkla.")

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if level < max_level:
				level_up()
			else:
				print("Maksimum seviyeye ulaşıldı!")

func level_up():
	var cost = get_level_up_cost()
	
	if GameManager.score >= cost:
		GameManager.score -= cost
		level += 1
		point = level * 3 
		if level == 1:
			modulate = Color(1, 1, 1, 1) 
			timer.start()
			$pidle1.play("new_animation")
			print("Patates açıldı! Üretim başladı.")
		
		print("Patates Seviye Atladı! Seviye: ", level, " | Puan: ", point)
	else:
		print("Patates için puan yetersiz! Gereken: ", cost)

func _on_timer_timeout():
	if level > 0:
		GameManager.score += point
		print("Patates puanı eklendi: +", point, " Toplam: ", GameManager.score)
