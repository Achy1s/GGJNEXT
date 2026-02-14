extends Area2D

var timer: Timer
var level: int = 1
var point: int = 1
var max_level: int = 3

func get_level_up_cost() -> int:
	return 30 * level

func _ready():
	if level == 1:
		$idlelevel1.play("new_animation")
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5.0
	timer.one_shot = false
	timer.autostart = true
	
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			speed_up(1.0)
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if level < max_level:
				level_up()

func speed_up(miktar: float):
	if timer.is_stopped(): return
	
	var new_time = timer.time_left - miktar
	if new_time <= 0.05:
		_on_timer_timeout()
		timer.start(10.0)
	else:
		timer.start(new_time)

func level_up():
	var cost = get_level_up_cost()
	
	if GameManager.score >= cost:
		GameManager.score -= cost
		level += 1
		point = (level * 2) - 1
		print("Seviye atladı! Yeni Seviye: ", level, " | Yeni Puan: ", point)
		# Burada yeni seviye animasyonunu tetikleyebilirsin
	else:
		print("Yetersiz puan! Gereken: ", cost)

func _on_timer_timeout():
	GameManager.score += point
	print("Puan kazanıldı! Toplam: ", GameManager.score)
