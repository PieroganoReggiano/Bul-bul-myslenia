extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	body.get_parent().remove_child(body)
	add_child(body)


func _on_body_entered(body: Node) -> void:
	body.get_parent().remove_child(body)
	add_child(body)
