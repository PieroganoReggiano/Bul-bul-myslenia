extends AudioStreamPlayer3D


var sounds : Dictionary = {
	"jump": load("res://jump.wav"),
	"bounce": load("res://bounce.wav"),
	"step": load("res://step.wav"),
	"landing": load("res://landing.wav"),
	"shoot": load("res://shoot.wav"),
	"antishoot": load("res://antishoot.wav"),
	"pop": load("res://pop.wav"),
	"clear": load("res://clear.wav"),
	"merge": load("res://merge.wav"),
	"stick": load("res://stick.wav"),
	"check": load("res://check.wav")
}


# add sound -- it receives new AudioStreamPlayer3D, which will disappear after sound is finished
func push(sound_name : String, release : bool = false) -> void:
	var sample = sounds.get(sound_name)
	if sample == null:
		return
	var new_sound = AudioStreamPlayer3D.new()
	if (not release):
		add_child(new_sound)
	else:
		SwiatContainer.get_world(self).add_child.call_deferred(new_sound)
	new_sound.stream = sample
	new_sound.finished.connect(func() -> void:
		remove_child(new_sound)
		new_sound.queue_free()
	)
	new_sound.play.call_deferred()


# play sound here -- it will not spawn new audio player -- playing a sound stops previous one
func say(sound_name : String) -> void:
	var sample = sounds.get(sound_name)
	if sample == null:
		return
	stream = sample
	play()
