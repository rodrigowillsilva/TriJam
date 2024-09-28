extends Node2D

#############################
# 	Variables 				#
#############################

# Flag to check if the player can whack
var can_whack: bool = true

# Onready variable for the animated sprite
@onready var animated = $AnimatedSprite2D

# Called when the node is added to the scene
func _ready() -> void:
	pass

#############################
# 	Functions 				#
#############################

# Called every frame
func _process(delta: float) -> void:
	# Follow the mouse cursor
	global_position = get_global_mouse_position()

# Function to handle the whack action
func whack() -> void:
	# Get all objects inside the collision shape
	var bodies = $WhackHitibox.get_overlapping_areas()
	
	# Loop through all objects and check if they are of the Caixa class
	var hits: Array[Caixa] = []
	print(bodies)
	for body in bodies:
		var c = body.get_parent()
		if c is Caixa:
			print("caixa")
			hits.append(c)

	# If there are any hits, find the closest one and call its Hit method
	if hits.size() > 0:
		var closest: Caixa = hits[0]
		for hit in hits:
			if hit.global_position.distance_to(global_position) < closest.global_position.distance_to(global_position):
				closest = hit
		
		closest.Hit()


#############################
# 	Callbacks Handlers		#
#############################

# Handle unhandled input events
func _unhandled_input(event: InputEvent) -> void:
	# Check if the left mouse button is pressed
	if event is InputEventMouseButton:
		if event.is_action_pressed("Left_mouse"):
			# Play the default animation
			animated.play("default")
			if can_whack:
				# If the player can whack, start the cooldown and call the whack function
				can_whack = false
				#$AnimationPlayer.play("whack")
				$Cooldown.start()
				whack()

# Cooldown timer timeout handler
func _on_cooldown_timeout() -> void:
	# Reset the can_whack flag
	can_whack = true
