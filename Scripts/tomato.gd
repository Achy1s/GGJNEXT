extends Area2D

var timer: Timer
var level: int = 1
var point: int = 1
var max_level: int = 3
var level_animations = ["tarla", "stand", "menemen"]

func get_level_up_cost() -> int:
	return 30 * level

func _ready():
	update_visuals()
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5.0
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func update_visuals():
	var current_anim = level_animations[level - 1]
	
	if $Sprite.sprite_frames.has_animation(current_anim):
		$Sprite.play(current_anim)
		print("Görsel güncellendi: ", current_anim)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if level < max_level:
				level_up()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			speed_up(1.0)

func speed_up(miktar: float):
	if timer.is_stopped(): return
	var new_time = timer.time_left - miktar
	if new_time <= 0.05:
		_on_timer_timeout()
		timer.start(5.0)
	else:
		timer.start(new_time)

func level_up():
	var cost = get_level_up_cost()
	
	if GameManager.score >= cost:
		GameManager.score -= cost
		level += 1
		point = (level * 2) - 1
		
		update_visuals()
		
		print("Tebrikler! Seviye: ", level)
	else:
		print("Yetersiz domates! Gereken puan: ", cost)

func _on_timer_timeout():
	GameManager.score += point
	print("Hasat yapıldı! +", point, " Toplam: ", GameManager.score)
