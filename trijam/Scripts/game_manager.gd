extends Node2D

class_name GameManager

#############################
# 	Variables 				#
#############################

# Exported variables for customization in the editor
@export var cores_caixa: Array[Color] = []  # Array of box colors
@export var score_scale: int = 1 			# Scale for scoring
@export var timer: Timer  					# Timer node
@export var game_time: int = 60  			# Game duration in seconds
@export var machine: Machine  				# Reference to the Machine node

# Onready variables for nodes that are ready when the scene is loaded
@onready var animplay = $"../AnimationPlayer"
@onready var score_label = $"../Score/Label"
@onready var final_label = $"../Canvas2/Control/Label"
@onready var audioplay = $"../AudioStreamPlayer"

# Variables for game state
var cor_gato: Color  			# Color of the cat
var score: int = 0  			# Player's score
var can_restart: bool = false	# Flag to check if the game can be restarted

#############################
# 	Signals 				#
#############################

# Signals for various game events
signal start_game
signal start_game_loop
signal end_game_true()
signal end_game_false()
signal spawn_caixa
signal score_points(points: int)

#############################
# 	Functions 				#
#############################

# Called when the node is added to the scene
func _ready() -> void:
	# Connect signals to their respective handlers
	end_game_true.connect(_on_main_game_ended)
	end_game_false.connect(_on_main_game_ended)
	
	# Set mouse mode to visible and play background audio
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	audioplay.play()

# Called every frame
func _process(delta: float) -> void:
	# Update the score label text
	score_label.text = str(score)
	
	# Check for restart input if the game can be restarted
	if can_restart == true:
		if Input.is_action_just_pressed("r_to_restart"):
			get_tree().reload_current_scene()

# Starts the game play
func start_play() -> void:
	# Randomly select a color for the cat
	cor_gato = cores_caixa[randi() % cores_caixa.size()]
	start_game.emit()
	
	# Play the menu animation and hide the mouse cursor
	animplay.play("menu_animation")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Callback for when a box is hit
func hit_caixa_callback(caixa: Caixa, s: int) -> void:
	print("hit")
	# Check if the color of the cat matches the box
	if cor_gato == caixa.cor:
		# Player wins
		end_game_true.emit()
	else:
		# Player scores points
		score += 100
		score_points.emit(s)

# Callback for when a box goes down
func go_down_caixa_callback(caixa: Caixa) -> void:
	print("ga_back")
	# Check if the color of the cat matches the box
	if cor_gato == caixa.cor:
		# Player wins
		pass
	else:
		# Player loses points
		score -= 25
		score_points.emit(score)


#############################
# 	Callbacks handlers   	#
#############################

# Timer timeout handler
func _on_timer_2_timeout() -> void:
	start_game_loop.emit()

# Start game loop handler
func _on_start_game_loop() -> void:
	$Timer.start()

# Timer timeout handler for ending the game
func _on_timer_timeout() -> void:
	end_game_false.emit()

# Handler for the "Play" button press
func _on_jogar_pressed() -> void:
	start_play()

# Handler for the "Quit" button press
func _on_sair_pressed() -> void:
	get_tree().quit()

# Handler for when the main game ends
func _on_main_game_ended() -> void:
	# Display the final score and play the game over animation
	final_label.text = str(score)
	animplay.play("game_over")
	can_restart = true

# Trigger to start the game loop
func start_game_loop_trigger():
	start_game_loop.emit()
