extends Node3D

#var volume : float = 100.0
@export var volume_level = 1
const default_radius = 1.0
const default_block_radius = 0.985
@onready var mesh = $MeshInstance3D

const magic_bounce_amplifitcation : float = 1.25
const magic_bounce_addition : float = 0.4
const magic_bounce_volume_addition : float = 0.004

func get_volume() -> float:
	match volume_level:
		1: return 100.0
		2: return 600.0
		3: return 2400.0
		_: return 100.0


func calc_scale() -> float:
	return pow(get_volume(), 1.0/3.0) / PI * 3 / 4


func refresh_scale() -> void:
	var s = calc_scale()
	$StaticBody3D/CollisionShape3D.shape.radius = default_block_radius * s - 0.04
	$Area/CollisionShape3D.shape.radius = default_block_radius * s
	mesh.scale = Vector3.ONE * s * 2.0
	


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
	var bounce = direction.dot(parkourowiec.velocity) * -direction
	parkourowiec.velocity += \
		bounce * (1.0 + 1.0 * magic_bounce_amplifitcation) + \
		direction * magic_bounce_addition + \
		direction * magic_bounce_volume_addition * get_volume()
	parkourowiec.move_and_slide()
	$WydawaczDzwiekow.push("bounce")
