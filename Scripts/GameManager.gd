extends Node

var score: int = 1000 
var is_double_score: bool = false
var bonus_timer: Timer
var bonus_cost: int = 200

func _ready():
	print("SİSTEM: GameManager Hazır!") # Bu yazı oyun açılınca çıkmalı
	bonus_timer = Timer.new()
	add_child(bonus_timer)
	bonus_timer.wait_time = 60.0
	bonus_timer.one_shot = true
	bonus_timer.timeout.connect(_on_bonus_timer_timeout)

func start_double_score_buff():
	if score >= bonus_cost:
		score -= bonus_cost
		is_double_score = true
		bonus_timer.start()
		print("--- SATIN ALMA BAŞARILI ---")
		print("is_double_score şu an: ", is_double_score)
	else:
		print("Yetersiz puan!")

func add_score(amount: int):
	# Hata ayıklama için her seferinde durumu yazdıralım
	print("add_score çağrıldı. Mevcut bonus durumu: ", is_double_score)
	
	if is_double_score:
		score += (amount * 2)
	else:
		score += amount
	
	print("Yeni Toplam Puan: ", score)

func _on_bonus_timer_timeout():
	is_double_score = false
	print("BONUS BİTTİ!")
