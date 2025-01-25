extends RigidBody3D

#var volume : float = 100.0
@export var volume_level = 0
@export var inflating : bool = 1
const default_radius = 1.0
const default_block_radius = 0.985
const pop_radius = 8.0
@onready var mesh = $MeshInstance3D


const magic_bounce_amplifitcation : float = 2#1.25
const magic_bounce_addition : float = 0.4
const magic_bounce_volume_addition : float = 0.004

var time_elapsed = 0
var scale_original = null

func get_volume() -> float:
	match volume_level:
		0: return 5.0
		1: return 100.0
		2: return 600.0
		3: return 2400.0
		_: return 100.0


func calc_scale() -> float:
	return pow(get_volume(), 1.0/3.0) / PI * 3 / 4


func refresh_scale(delta: float) -> void:
	if inflating:
		time_elapsed += delta * 4.0
	var s = calc_scale()
	$CollisionShape3D.shape.radius = default_block_radius * s * (1.0 + time_elapsed) - 0.04 * (1.0 + time_elapsed)
	$PushArea/CollisionShape3D.shape.radius = default_block_radius * s * (1.0 + time_elapsed)
	$StickArea/CollisionShape3D.shape.radius = default_block_radius * s * (1.0 + time_elapsed)
	mesh.scale = Vector3.ONE * s * 2.0 * (1.0 + time_elapsed)
	if scale_original == null:
		scale_original = mesh.scale
	if mesh.scale > scale_original * pop_radius:
		queue_free()
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_scale(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	refresh_scale(delta)


func _on_pusharea_body_entered(body: Node) -> void:
	print("Sticky bubble bounce-collided with: " + body.get_name())
	if body is Parkourowiec:
		bounce_parkourowiec(body)
	pass # Replace with function body.

func _on_stickarea_body_entered(body: Node) -> void:
	freeze = true
	inflating = false
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
