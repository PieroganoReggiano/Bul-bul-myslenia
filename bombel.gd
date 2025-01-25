extends RigidBody3D

var volume : float = 100.0
const default_radius = 1.0
@onready var mesh = $MeshInstance3D


func calc_scale() -> float:
	return pow(volume, 1.0/3.0) / PI * 3 / 4


func refresh_scale() -> void:
	var s = calc_scale()
	$CollisionShape3D.shape.radius = default_radius * s
	mesh.scale = Vector3.ONE * s * 2.0
	print(s)
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_scale()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	refresh_scale()
