class_name BlueBubble
extends RigidBody3D

@export var lift_time: float = 5.0  # Time to lift the object
@export var lift_force_multiplier: float = 3.0  # Multiplier for lift force
@export var max_lift_height: float = 3.0  # Maximum height to which the object can be lifted
@export var return_acceleration: float = 5.0  # Acceleration factor for smooth return
@export var return_speed: float = 0.1  # Interpolation factor for smooth return
@export var stop_return_distance: float = 0.01  # Stop returning when this distance is reached
@export var attachment_offset: Vector3 = Vector3(0, 1, 0)  # Offset for Bombel position relative to the object
@export var scale_speed: float = 0.5  # Speed at which Bombel grows during lifting
@export var max_scale: float = 3.0  # Maximum scale for Bombel

@onready var area = $LiftArea
@onready var visual = $MeshInstance3D  # Reference to Bombel's visual node

var lifting: bool = false
var timer: float = 0.0
var time_elapsed : float = 0.0
var attached_body: RigidBody3D = null
var original_position: Vector3 = Vector3.ZERO
var returning: bool = false

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float):
	# Lifting logic
	time_elapsed += delta
	if not freeze:
		if time_elapsed >= 8.0:
			queue_free()
	if lifting and is_instance_valid(attached_body):
		timer -= delta
		if timer <= 0.0:
			stop_lifting()
		else:
			# Lift the object
			var current_height = attached_body.global_position.y
			var target_height = original_position.y + max_lift_height

			if current_height < target_height:
				var required_force = attached_body.mass * 9.8 * lift_force_multiplier
				attached_body.apply_central_force(Vector3.UP * required_force)
			else:
				attached_body.linear_velocity = Vector3.ZERO
				attached_body.angular_velocity = Vector3.ZERO

			self.global_position = attached_body.global_position + attachment_offset

			if visual.scale.x < max_scale:
				visual.scale += Vector3.ONE * scale_speed * delta

	# Smooth return to original position
	if returning and is_instance_valid(attached_body):
		# Disable physics reactions
		attached_body.freeze = true

		# Move the object back to its original position smoothly using lerp
		attached_body.global_position = attached_body.global_position.lerp(original_position, return_speed)

		# Check if the object is close enough to stop returning
		if attached_body.global_position.distance_to(original_position) <= stop_return_distance:
			returning = false
			attached_body.freeze = false  # Re-enable physics
			attached_body = null

			# Queue Bombel for removal
			queue_free()
		
func _on_body_entered(body):
	if attached_body == null and body is RigidBody3D and body.has_method("apply_central_force"):
		attached_body = body
		original_position = body.global_position

		area.monitoring = false
		self.global_position = body.global_position + attachment_offset

		start_lifting()

func start_lifting():
	if lifting:
		return
	lifting = true
	timer = lift_time

func stop_lifting():
	lifting = false
	returning = true
	visual.visible = false  # Bombel disappears immediately after lifting ends


func _on_tree_exiting() -> void:
	$WydawaczDzwiekow.push("pop", true)
