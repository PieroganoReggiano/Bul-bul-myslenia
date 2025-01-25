extends RigidBody3D

@export var lift_time: float = 5.0  # Time to lift the object
@export var lift_force_multiplier: float = 10.0  # Multiplier for lift force
@export var return_speed: float = 0.1  # Interpolation factor for smooth return
@export var stop_return_distance: float = 0.01  # Stop returning when this distance is reached
@export var attachment_offset: Vector3 = Vector3(0, 1, 0)  # Offset for Bombel position relative to the object

@onready var area = $LiftArea
var lifting: bool = false
var timer: float = 0.0
var attached_body: RigidBody3D = null
var original_position: Vector3 = Vector3.ZERO
var returning: bool = false

func _ready():
	# Connect the body_entered signal
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	print("Bombel is ready and monitoring collisions.")

func _physics_process(delta: float):
	# Lifting logic
	if lifting and is_instance_valid(attached_body):
		timer -= delta
		if timer <= 0.0:
			print("Lifting time ended. Releasing object.")
			stop_lifting()
		else:
			# Apply a strong upward force to lift the attached object
			var required_force = attached_body.mass * 9.8 * lift_force_multiplier
			attached_body.apply_central_force(Vector3.UP * required_force)

			# Synchronize Bombel's position with the attached object
			self.global_position = attached_body.global_position + attachment_offset

	# Smoothly return the object to its original position
	if returning and is_instance_valid(attached_body):
		# Disable physics reactions
		attached_body.freeze = true

		# Move the object back to its original position smoothly using lerp
		attached_body.global_position = attached_body.global_position.lerp(original_position, return_speed)

		# Check if the object is close enough to stop returning
		if attached_body.global_position.distance_to(original_position) <= stop_return_distance:
			print("Object returned to its original position.")
			returning = false
			attached_body.freeze = false  # Re-enable physics
			attached_body = null

			# Queue Bombel for removal
			queue_free()

func _on_body_entered(body):
	# Attach to the object if no other body is already attached
	if attached_body == null and body is RigidBody3D and body.has_method("apply_central_force"):
		print("Collision detected with: ", body)
		attached_body = body
		original_position = body.global_position  # Save the object's original position

		# Attach Bombel to the object
		area.monitoring = false
		self.global_position = body.global_position + attachment_offset

		print("Bombel attached to object: ", body)
		start_lifting()

func start_lifting():
	if lifting:
		return  # Avoid duplicate lifting logic
	lifting = true
	timer = lift_time
	print("Lifting started. Timer: ", lift_time)

func stop_lifting():
	# Stop lifting and prepare to return the object
	lifting = false
	returning = true
	print("Lifting stopped.")

func _exit_tree():
	# Clean up the signal connection
	if area:
		area.disconnect("body_entered", Callable(self, "_on_body_entered"))
