extends AudioStreamPlayer3D

var sound_bounce = load("res://bounce.wav")

func push_bounce() -> void:
	stream = sound_bounce
	play()
