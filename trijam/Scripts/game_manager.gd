extends Node2D

class_name GameManager

@export var cores_caixa: Array[Color] = []
@export var score_scale: int = 1
@export var timer: Timer
@export var game_time: int = 60
@export var machine: Machine
var cor_gato: Color
var score: int = 0

#signals
signal start_game
signal start_game_loop
signal end_game(cat: bool)
signal spawn_caixa
signal score_points(points: int)

func _ready() -> void:
	start_play()
	

func start_play() -> void:
	cor_gato = cores_caixa[randi() % cores_caixa.size()]
	start_game.emit()
	pass

func hit_caixa_callback(caixa: Caixa, s: int) -> void:
	print("hit")
	# check if the color of the cat is the same as the box
	if cor_gato == caixa.cor:
		# if it is the same, the player wins
		end_game.emit(true)
	else:
		# if it is not the same, the player loses
		score += s * score_scale
		score_points.emit(s)
	pass

func go_down_caixa_callback(caixa: Caixa) -> void:
	print("ga_back")
	# check if the color of the cat is the same as the box
	if cor_gato == caixa.cor:
		# if it is the same, the player wins
		#end_game.emit(true)
		pass
	else:
		# if it is not the same, the player loses
		score -= score_scale
		score_points.emit(score)
	pass
	

func _on_timer_2_timeout() -> void:
	start_game_loop.emit()


func _on_start_game_loop() -> void:
	$Timer.start()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	end_game.emit(false)
	pass # Replace with function body.
