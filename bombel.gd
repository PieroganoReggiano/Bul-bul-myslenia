extends RigidBody3D

#var volume : float = 100.0
var volume_level = 1
const default_radius = 1.0
@onready var mesh = $MeshInstance3D


func get_volume() -> float:
	match volume_level:
		1: return 100.0
		2: return 600.0
		3: return 3000.0
		_: return 100.0


func calc_scale() -> float:
	return pow(get_volume(), 1.0/3.0) / PI * 3 / 4


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


func _on_body_entered(body: Node) -> void:
	if body is Parkourowiec:
		bounce_parkourowiec(body)
	pass # Replace with function body.


func bounce_parkourowiec(parkourowiec : Parkourowiec) -> void:
	var direction : Vector3 = parkourowiec.position - position
	direction = direction.normalized()
	parkourowiec.apply_impulse(direction * 10.0)
