extends Area2D

var timer: Timer
var level: int = 1
var point: int = 1
var max_level: int = 3
var level_animations = ["tarla", "stand", "menemen"]
var click_level: int = 1
var click_power: float = 1.0

func get_level_up_cost() -> int:
	return 30 * level

func get_click_upgrade_cost() -> int:
	return 100 * click_level

func _ready():
	update_visuals()
	get_node("../UI/Button").pressed.connect(_on_upgrade_button_pressed)
	
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
	if level > 0:
		GameManager.score += point
		show_floating_point(point)
		print("Domates puanı eklendi: +", point, " Toplam: ", GameManager.score)

func _on_upgrade_button_pressed():
	var cost = get_click_upgrade_cost()
	
	if GameManager.score >= cost:
		GameManager.score -= cost
		click_level += 1
		click_power += 0.5
		
		print("Tıklama gücü arttı! Yeni Güç: ", click_power)
	else:
		print("Yetersiz puan! Gereken: ", cost)

func show_floating_point(amount: int):
	var sprite = Sprite2D.new()
	
	# Texture'ı yükle
	sprite.texture = load("res://assets/puan_" + str(amount) + ".png")
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	
	# --- RASTGELE SAPMA (RANDOM OFFSET) EKLEME ---
	# Yatayda -25 ile +25 pixel arası rastgele bir sapma ekler
	var random_x = randf_range(-25.0, 25.0)
	sprite.position = Vector2(random_x, -20) 
	# ---------------------------------------------

	sprite.z_index = 10
	# Sayıların birbirinin aynısı durmaması için hafif bir rastgele rotasyon da ekleyebilirsin
	sprite.rotation_degrees = randf_range(-15.0, 15.0)

	var tween = create_tween()
	tween.set_parallel(true)
	
	# Yukarı kayarken aynı zamanda rastgele yana doğru da hafifçe süzülsün
	var target_pos = Vector2(sprite.position.x + (random_x * 0.5), sprite.position.y - 60)
	
	tween.tween_property(sprite, "position", target_pos, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "modulate:a", 0.0, 1.2)
	# Hafif büyüme efekti (Opsiyonel)
	sprite.scale = Vector2(0.5, 0.5)
	tween.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.2)
	
	tween.chain().tween_callback(sprite.queue_free)
