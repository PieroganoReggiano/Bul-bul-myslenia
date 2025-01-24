class_name Parkourowiec
extends CharacterBody3D


const BASE_SPEED = 5.0
const SPEED_MULTIPLIER = 2.0
const JUMP_VELOCITY = 4.5
const CROUCH_MULTIPLIER = 0.5

const BASE_SCALE = Vector3(1, 1, 1)
const CROUCH_SCALE = Vector3(1, 0.5, 1)


func rotate_input(r : Vector2) -> void:
	r *= 0.003
	rotation.y -= r.x
	rotation.x -= r.y
	rotation.x = clamp(rotation.x, -PI * 0.5, PI * 0.5)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var speed = BASE_SPEED
	if Input.is_action_pressed("move_speed"):
		speed *= SPEED_MULTIPLIER
	elif Input.is_action_pressed("move_crouch"):
		speed *= CROUCH_MULTIPLIER


	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED)
		velocity.z = move_toward(velocity.z, 0, BASE_SPEED)
	
	if Input.is_action_pressed("move_crouch"):
		scale = CROUCH_SCALE
	else:
		scale = BASE_SCALE
	
	move_and_slide()
