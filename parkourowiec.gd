class_name Parkourowiec
extends CharacterBody3D


const BASE_SPEED = 5.0
const SPEED_MULTIPLIER = 2.0
const JUMP_VELOCITY = 4.5
const CROUCH_MULTIPLIER = 0.5

const BASE_SCALE = Vector3(1, 1, 1)
const CROUCH_SCALE = Vector3(1, 0.5, 1)

@onready var camera: Camera3D = $Glowa/Camera3D
@onready var head: Node3D = $Glowa

var vertical_rotation = 0.0
var vertical_look_limit = 89.0

func rotate_input(r : Vector2) -> void:
	r *= 0.003
	# Obrót poziomy (oś Y)
	rotate_y(-r.x)

	# Obrót pionowy (oś X)
	vertical_rotation -= r.y
	vertical_rotation = clamp(vertical_rotation, -deg_to_rad(vertical_look_limit), deg_to_rad(vertical_look_limit))
	head.rotation_degrees.x = rad_to_deg(vertical_rotation)

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
