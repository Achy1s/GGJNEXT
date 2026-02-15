extends Area2D

var timer: Timer
var level: int = 0 
var point: int = 0
var max_level: int = 3

var animations = ["kilitli", "tarla", "stand", "menemen"]

func get_level_up_cost() -> int:
	if level == 0:
		return 50
	return 30 * level

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5.0
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	
	update_visuals()

func update_visuals():
	var anim_name = animations[level]
	
	if $Sprite.sprite_frames.has_animation(anim_name):
		$Sprite.play(anim_name)
	
	if level == 0:
		modulate = Color(0.3, 0.3, 0.3, 0.8)
		print("Domates kilitli! Açmak için sağ tıkla.")
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
		point = level * 3 
		update_visuals()
		if level == 1:
			timer.start()
			print("Domates açıldı! Üretim başladı.")
		
		print("Domates Seviye Atladı! Seviye: ", level, " | Puan: ", point)
	else:
		print("Domates için puan yetersiz! Gereken: ", cost)

func _on_timer_timeout():
	if level > 0:
		GameManager.score += point
		show_floating_point(point) # Bu satırı ekledik
		print("Domates puanı eklendi: +", point, " Toplam: ", GameManager.score)

func show_floating_point(amount: int):
	var sprite = Sprite2D.new()
	
	# Texture'ı yükle
	sprite.texture = load("res://art/puan_" + str(amount) + ".png")
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
