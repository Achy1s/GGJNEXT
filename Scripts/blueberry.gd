extends Area2D

var timer: Timer
var level: int = 0 
var point: int = 0
var max_level: int = 3

var animations = ["kilitli", "tarla", "jam", "pancake"]

func get_level_up_cost() -> int:
	if level == 0:
		return 100
	return 75 * level

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 10.0
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	
	update_visuals()

func update_visuals():
	var anim_name = animations[level]
	
	if $Sprite.sprite_frames.has_animation(anim_name):
		$Sprite.play(anim_name)
	
	if level == 0:
		modulate = Color(0.3, 0.3, 0.3, 0.8)
		print("Patates kilitli! Açmak için sağ tıkla.")
	else:
		modulate = Color(1, 1, 1, 1)

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
		point = level * 10
		update_visuals()
		if level == 1:
			timer.start()
			print("Mısır açıldı! Üretim başladı.")
		
		print("Mısır Seviye Atladı! Seviye: ", level, " | Puan: ", point)
	else:
		print("Mısır için puan yetersiz! Gereken: ", cost)

func _on_timer_timeout():
	if level > 0:
		GameManager.score += point
		print("Mısır puanı eklendi: +", point, " Toplam: ", GameManager.score)
