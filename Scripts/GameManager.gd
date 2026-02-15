extends Node

var score: int = 0
var is_double_score: bool = false
var bonus_timer: Timer
var bonus_cost: int = 200

func _ready():
	bonus_timer = Timer.new()
	add_child(bonus_timer)
	bonus_timer.wait_time = 60.0
	bonus_timer.one_shot = true
	bonus_timer.timeout.connect(_on_bonus_timer_timeout)

func add_score(amount: int):
	if is_double_score:
		score += amount * 2
	else:
		score += amount
	
	print("Güncel Puan: ", score)

func start_double_score_buff():
	var bonus_cost = 200
	
	if score >= bonus_cost:

		
		if is_double_score:
			bonus_timer.start() 
			print("Bonus zaten aktifti, süre 1 dakikaya sıfırlandı!")
		else:
			score -= bonus_cost
			is_double_score = true
			bonus_timer.start()
			print("2 KAT PUAN SATIN ALINDI! (60 Saniye)")
			
	else:
		print("Yetersiz puan! Bonus için 200 puan gerekiyor. Mevcut: ", score)

func _on_bonus_timer_timeout():
	is_double_score = false
	print("SÜRE BİTTİ! Puan kazancı normale döndü.")
