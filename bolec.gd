extends Area3D

@onready var korzen = SwiatContainer.get_world(self).get_node("../..")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if korzen.has_method("revive") and body is Parkourowiec:
		korzen.revive()
