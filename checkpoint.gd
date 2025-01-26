class_name Checkpoint
extends Area3D


@onready var korzen = SwiatContainer.get_world(self).get_node("../..")


func check(parkourowiec : Parkourowiec) -> bool:
	return korzen.check(self, parkourowiec)


func refresh_colour() -> void:
	var colour = korzen.get_checkpoint_color(self)
	if colour == Color.TRANSPARENT:
		queue_free()
		return
	var mat = $MeshInstance3D.get_surface_override_material(0) as ShaderMaterial
	mat.set_shader_parameter("colour", colour)


func _physics_process(_delta: float) -> void:
	refresh_colour()


func _on_body_entered(body: Node3D) -> void:
	if body is Parkourowiec:
		if check(body):
			$WydawaczDzwiekow.push("check")
