extends Sprite2D

class_name CaixaAberta

static var index: int = 0
@onready var gm = get_node("../../../Game Manager") as GameManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gm.start_game.connect(on_start_game)
	
	
func on_start_game() -> void:
	$%AnimatedSprite2D.visible = false
	%"fita caixa aberta".self_modulate = gm.cores_caixa[index]
	index = index + 1
	if index == gm.cores_caixa.size():
		index = 0
	
	print(gm.cor_gato)
	print(%"fita caixa aberta".self_modulate)
	
	if %"fita caixa aberta".self_modulate == gm.cor_gato:
		$%AnimatedSprite2D.visible = true
		
		await get_tree().create_timer(1.5).timeout
		$AnimatedSprite2D.play()
