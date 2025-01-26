class_name LevelEnd
extends Area3D

@onready var korzen = SwiatContainer.get_world(self).get_node("../..")

@export var next_level : String = ""

func go(parkourowiec : Parkourowiec) -> bool:
	return korzen.try_end_level(parkourowiec, self)


func _on_body_entered(body: Node3D) -> void:
	if body is Parkourowiec:
		go(body)
