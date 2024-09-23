extends Node2D

var can_whack: bool = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	#follow the mouse
	global_position = get_global_mouse_position()
	

func whack() -> void:
	# get all onjects inside the collision shape
	var bodies = $WhackHitibox.get_overlapping_areas() 
	# loop through all objects and check if they are the Caixa class and get the closest one
	var hits: Array[Caixa] = []
	print(bodies)
	for body in bodies:
		var c = body.get_parent()
		if c is Caixa:
			print("caixa")
			hits.append(c)

	if hits.size() > 0:
		var closest: Caixa = hits[0]
		for hit in hits:
			if hit.global_position.distance_to(global_position) < closest.global_position.distance_to(global_position):
				closest = hit
		
		closest.Hit()
		# $AnimationPlayer.play("whack")
		# $CollisionShape2D.disabled = true
		# $Timer.start()


	# $AnimationPlayer.play("whack")
	# $CollisionShape2D.disabled = true
	# $Timer.start()
	pass

func _unhandled_input(event: InputEvent) -> void:
	#check if left mouse button is pressed
	if event is InputEventMouseButton:
		if event.is_action_pressed("Left_mouse"):
			#print("click")
			if can_whack:
				can_whack = false
				#$AnimationPlayer.play("whack")
				$Cooldown.start()
				whack()
	


func _on_cooldown_timeout() -> void:
	can_whack = true
