extends Node2D

class_name Machine

#############################
# 	Variables 				#
#############################

# Exported variables for customization in the editor
@export var caixas: Array[Caixa] = []  		# Array of box nodes
@export var spanw_curve: Curve  			# Curve for spawn timing
@export var initial_spawn_time: float = 3  	# Initial spawn time for boxes
@export var max_spawn_time: float = 5  		# Maximum spawn time for boxes

# Reference to the GameManager node
var game_manager: GameManager

# Weights for each color
var color_weights: Dictionary = {}

#############################
# 	Functions 				#
#############################

# Called when the node is added to the scene
func _ready() -> void:
	# Get the GameManager node
	game_manager = get_node("../Game Manager") as GameManager

	# Initialize weights
	for color in game_manager.cores_caixa:
		color_weights[color] = 1.0 / game_manager.cores_caixa.size()
	
	# Connect signals to their respective handlers
	game_manager.start_game_loop.connect(on_start_game_loop)
	game_manager.end_game_true.connect(on_end_game)
	game_manager.end_game_false.connect(on_end_game)

func select_color() -> Color:
	var total_weight = 0.0
	for weight in color_weights.values():
		total_weight += weight
		
	var random_value = randf() * total_weight
	var cumulative_weight = 0.0
		
	for color in color_weights.keys():
		cumulative_weight += color_weights[color]
		if random_value < cumulative_weight:
			update_weights(color)
			return color

	return Color(1, 1, 1, 1)


func update_weights(selected_color: Color) -> void:
	for color in color_weights.keys():
		if color == selected_color:
			color_weights[color] *= 0.5  # Decrease weight of selected color
		else:
			color_weights[color] += (1.0 - color_weights[color]) * 0.1  # Increase weight of other colors
	
	normalize_weights()

func normalize_weights() -> void:
	var total_weight = 0.0
	for weight in color_weights.values():
		total_weight += weight
	
	for color in color_weights.keys():
		color_weights[color] /= total_weight


#############################
# 	Callbacks Handlers		#
#############################

# Handler for starting the game loop
func on_start_game_loop() -> void:
	# Set the spawn timer's wait time based on the initial spawn time and curve
	$SpawnTimer.wait_time = initial_spawn_time * spanw_curve.sample(0)
	$SpawnTimer.start()

# Handler for ending the game
func on_end_game() -> void:
	# Stop the spawn timer
	$SpawnTimer.stop()

# Handler for the spawn timer timeout
func _on_spawn_timer_timeout() -> void:
	# Get a random box from the list that can go
	var caixa = caixas[randi() % caixas.size()]
	while !caixa.can_go:
		caixa = caixas[randi() % caixas.size()]
	
	# Start the box movement
	caixa.start_move(select_color())
	
	# Calculate the play time interval based on the remaining game time
	var play_time_inter = 1.0 - ((game_manager.timer.time_left + randf_range(-5, 5)) / game_manager.game_time)
	play_time_inter = clamp(play_time_inter, 0, 1)
	
	# Set the spawn timer's wait time based on the play time interval and curve
	$SpawnTimer.wait_time = randf_range(1.5, 2) * spanw_curve.sample(play_time_inter)
	$SpawnTimer.start()
