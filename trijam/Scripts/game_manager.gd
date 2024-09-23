extends Node2D

class_name GameManager

@export var cores_caixa: Array[Color] = []
@export var score_scale: int = 1
@export var timer: Timer
@export var game_time: int = 60
@export var machine: Machine
@onready var animplay = $"../AnimationPlayer"
@onready var fita_caixa_aberta = %"fita caixa aberta"
@onready var gatinho = %AnimatedSprite2D
@onready var score_label = $"../Score/Label"
@onready var final_label = $"../Canvas2/Control/Label"
@onready var audioplay = $"../AudioStreamPlayer"
var cor_gato: Color
var score: int = 0
var can_restart : bool = false

#signals
signal start_game
signal start_game_loop
signal end_game_true()
signal end_game_false()
signal spawn_caixa
signal score_points(points: int)

func _ready() -> void:
	#start_play()
	end_game_true.connect(_on_main_game_ended)
	end_game_false.connect(_on_main_game_ended)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	audioplay.play()

func _process(delta: float) -> void:
	score_label.text = str(score)
	if can_restart == true:
		if Input.is_action_just_pressed("r_to_restart"):
			get_tree().reload_current_scene()

func start_play() -> void:
	cor_gato = cores_caixa[randi() % cores_caixa.size()]
	fita_caixa_aberta.modulate = cor_gato
	gatinho.play()
	start_game_loop.emit()
	animplay.play("menu_animation")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func hit_caixa_callback(caixa: Caixa, s: int) -> void:
	print("hit")
	# check if the color of the cat is the same as the box
	if cor_gato == caixa.cor:
		# if it is the same, the player wins
		end_game_true.emit()
	else:
		# if it is not the same, the player loses
		score += 100
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
		score -= 200
		score_points.emit(score)
	pass
	

func _on_timer_2_timeout() -> void:
	start_game_loop.emit()


func _on_start_game_loop() -> void:
	$Timer.start()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	end_game_false.emit()
	pass # Replace with function body.


func _on_jogar_pressed() -> void:
	start_play()


func _on_sair_pressed() -> void:
	get_tree().quit()

func _on_main_game_ended() -> void:
	final_label.text = str(score)
	animplay.play("game_over")
	can_restart = true
