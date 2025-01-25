extends AudioStreamPlayer3D

var sound_jump = load("res://jump.wav")

func push_jump() -> void:
	stream = sound_jump
	play()
