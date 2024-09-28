extends Node2D

class_name Caixa

#############################
# 	Variables 				#
#############################

# Exported variables for customization in the editor
@export var game_manager: GameManager = null  			# Reference to the GameManager node
@export var caixa_normal: CompressedTexture2D = null  	# Normal box texture *(not used)*
@export var caixa_hit: CompressedTexture2D = null  		# Hit box texture *(not used)*
@export var bounce_curve: Curve 					 	# Curve for bounce animation timing
@export var bounce_max_value: float = 2  				# Maximum value for bounce timing

# Onready variables for nodes that are ready when the scene is loaded
@onready var sprite2d = $fite_sprite  # Reference to the sprite node

# Variables for box state
var cor: Color = Color.WHITE  # Color of the box
var can_go: bool = true  # Flag to check if the box can move

#############################
# 	Signals 				#
#############################

# Signal for when the box is hit
signal hit(caixa: Caixa, score: int)


#############################
# 	Functions 				#
#############################

# Called when the node is added to the scene
func _ready() -> void:
	# Connect signals to their respective handlers
	hit.connect(game_manager.hit_caixa_callback)
	game_manager.end_game_true.connect(on_end_game)
	game_manager.end_game_false.connect(on_end_game)
	
	# Disable the collision shape initially
	$HitBox/CollisionShape2D.disabled = true

# Starts the movement of the box
func start_move(selected_color: Color) -> void:
	# Get a random value from the curve and set the wait time in the Bounce Timer
	$caixa_sprite.visible = true
	$caixa_amassada_1.visible = false
	var play_time_inter = 1.0 - ((game_manager.timer.time_left + randf_range(-5, 5)) / game_manager.game_time)
	play_time_inter = clamp(play_time_inter, 0, 1)

	$BounceTime.wait_time = bounce_curve.sample(play_time_inter) * bounce_max_value
	$BounceTime.start()
	can_go = false
	change_sprite(caixa_normal)
	$HitBox/CollisionShape2D.disabled = false
	change_color(selected_color)
	$AnimationPlayer.play("go_up")
	pass

func change_color(color: Color) -> void:
	cor = color
	sprite2d.modulate = color


# (Function not used)
func change_sprite(sprite: CompressedTexture2D) -> void:
	#sprite2d.texture = sprite
	pass


func Hit() -> void:
	$caixa_amassada_1.visible = true
	$caixa_sprite.visible = false
	hit.emit(self, $BounceTime.time_left/$BounceTime.wait_time)
	can_go = false
	change_sprite(caixa_hit)
	$AnimationPlayer.play("hit")
	$HitBox/CollisionShape2D.disabled = true
	$Cooldown.start()
	$BounceTime.stop()
	pass


#############################
# 	Callbacks Handlers		#
#############################

# Handler for when the game ends
func on_end_game():
	# Stop the animation and play the hit animation
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	
	# Stop the game timer and allow the box to move again
	game_manager.timer.stop()
	can_go = true

func _on_cooldown_timeout() -> void:
	can_go = true


func _on_bounce_time_timeout() -> void:
	$AnimationPlayer.play("go_down")
	$HitBox/CollisionShape2D.disabled = true
	$Cooldown.start()
	pass # Replace with function body.

func on_go_down() -> void:
	game_manager.go_down_caixa_callback(self)
	pass
