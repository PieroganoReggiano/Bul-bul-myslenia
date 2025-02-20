extends StaticBody3D

signal on_pressed
signal on_released

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	on_pressed.emit()


func _on_area_3d_body_exited(body: Node3D) -> void:
	on_released.emit()
