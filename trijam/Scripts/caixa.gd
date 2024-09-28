extends Node2D

class_name Caixa

@export var game_manager: GameManager = null
@export var caixa_normal: CompressedTexture2D = null
@export var caixa_hit: CompressedTexture2D = null
@export var bounce_curve: Curve
@export var bounce_max_value: float = 2
@onready var sprite2d = $fite_sprite
var cor: Color = Color.WHITE
var can_go: bool = true

signal hit(caixa: Caixa, score: int)

func _ready() -> void:
	hit.connect(game_manager.hit_caixa_callback)
	game_manager.end_game_true.connect(on_end_game)
	game_manager.end_game_false.connect(on_end_game)
	$HitBox/CollisionShape2D.disabled = true
	
func on_end_game():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit")
	game_manager.timer.stop()
	can_go = true

func start_move() -> void:
	# get a random value from the curve and set the wait time in the Bounce Timer
	$caixa_sprite.visible = true
	$caixa_amassada_1.visible = false
	var play_time_inter = 1.0 - ((game_manager.timer.time_left + randf_range(-5, 5)) / game_manager.game_time)
	play_time_inter = clamp(play_time_inter, 0, 1)
	print(play_time_inter)
	$BounceTime.wait_time = bounce_curve.sample(play_time_inter) * bounce_max_value
	print($BounceTime.wait_time)
	$BounceTime.start()

	change_sprite(caixa_normal)
	$HitBox/CollisionShape2D.disabled = false
	var random_color = game_manager.cores_caixa[randi() % game_manager.cores_caixa.size()]
	change_color(random_color)
	$AnimationPlayer.play("go_up")
	pass

func change_color(color: Color) -> void:
	cor = color
	sprite2d.modulate = color


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
