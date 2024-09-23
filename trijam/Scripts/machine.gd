extends Node2D

class_name Machine

@export var caixas: Array[Caixa] = []
@export var spanw_curve: Curve
@export var max_spawn_time: float = 5
var game_manager: GameManager

func _ready() -> void:
	# get the game manager
	game_manager = get_node("../Game Manager") as GameManager
	# connect the hit signal to the game manager
	game_manager.start_game_loop.connect(on_start_game_loop)


func on_start_game_loop() -> void:
	$SpawnTimer.wait_time = max_spawn_time * spanw_curve.sample(0)
	$SpawnTimer.start()
	pass


func _on_spawn_timer_timeout() -> void:
	# get a random caixa from the list that can_go is true
	var caixa = caixas[randi() % caixas.size()]
	while !caixa.can_go:
		caixa = caixas[randi() % caixas.size()]
	
	caixa.start_move()
	var play_time_inter = 1.0 - ((game_manager.timer.time_left + randf_range(-5, 5)) / game_manager.game_time)
	play_time_inter = clamp(play_time_inter, 0, 1)
	
	$SpawnTimer.wait_time = max_spawn_time * spanw_curve.sample(play_time_inter)
	$SpawnTimer.start()

	pass # Replace with function body.
