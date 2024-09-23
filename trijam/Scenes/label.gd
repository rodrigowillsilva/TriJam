extends Label

var timer: Timer

func _ready():
	timer = get_node("../Game Manager").get_node("Timer") as Timer

func _process(delta: float) -> void:
	text = "%.2f" % timer.time_left
