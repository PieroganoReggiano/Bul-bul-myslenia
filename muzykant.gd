extends AudioStreamPlayer

var main_theme = load("res://cool-bubbles.ogg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = main_theme
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
