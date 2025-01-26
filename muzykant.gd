extends AudioStreamPlayer

var main_theme = load("res://cool-bubbles.ogg")
var przegranko_start = load("res://lost-bubbles-start.ogg")
var przegranko_loop = load("res://lost-bubbles-loop.ogg")
var win_theme = load("res://super-cool-bubbles.ogg")

var next : AudioStream

func _ready() -> void:
	play_main()


func play_main() -> void:
	if stream == main_theme:
		return
	stream = main_theme
	play()


func play_lose() -> void:
	stream = przegranko_start
	next = przegranko_loop
	play()


func play_win() -> void:
	stream = win_theme
	play()


func _on_finished() -> void:
	if next:
		stream = next
		next = null
		play()
