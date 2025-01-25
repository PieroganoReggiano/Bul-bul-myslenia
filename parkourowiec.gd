class_name Parkourowiec
extends CharacterBody3D


const BASE_SPEED = 5.0
const AIRSTRAFE_SPEED = 0.15
const SPEED_MULTIPLIER = 2.0
const JUMP_VELOCITY = 4.5
const CROUCH_MULTIPLIER = 0.5

const BASE_SCALE = Vector3(1, 1, 1)
const CROUCH_SCALE = Vector3(1, 0.5, 1)

@onready var camera: Camera3D = $Glowa/Camera3D
@onready var head: Node3D = $Glowa
@onready var gun: MeshInstance3D = $Glowa/Gun
@onready var gun_czubek: Node3D = $Glowa/Gun/gun_czubek
@onready var gun_base: Node3D = $Glowa/Gun/gun_base
@onready var wydawacz_dzwiekow = $WydawaczDzwiekow

var vertical_rotation = 0.0
var vertical_look_limit = 90.0

var was_on_floor : bool = true

var movement_input_state := Vector2(0.0, 0.0)
var jump_state = false

var walk_integral : float = 0.0
var step_sound_threshold : float = 2.0

@export var naboj_scene: PackedScene = preload("res://sceny/sticky_bombel.tscn")

func shoot():
	if not naboj_scene:
		return
	
	# Tworzenie instancji naboju
	var naboj = naboj_scene.instantiate() as RigidBody3D
	
	# Ustawienie pozycji naboju na czubku guna
	naboj.global_transform = gun_czubek.global_transform
	
	# Dodanie naboju do sceny
	get_tree().current_scene.add_child(naboj)
	
	# Kierunek strzału (oparty na pozycji pistola)
	var world_direction = (gun_czubek.global_transform.origin - gun_base.global_transform.origin).normalized()
	# Nadanie prędkości naboju
	var speed = 40
	naboj.apply_impulse(world_direction * speed)

	print("Kierunek strzału: ", world_direction * speed)



func rotate_input(r : Vector2) -> void:
	r *= 0.003
	# Obrót poziomy (oś Y)
	rotate_y(-r.x)

	# Obrót pionowy (oś X)
	vertical_rotation -= r.y
	vertical_rotation = clamp(vertical_rotation, -deg_to_rad(vertical_look_limit), deg_to_rad(vertical_look_limit))
	head.rotation_degrees.x = rad_to_deg(vertical_rotation)


func move_input(vec : Vector2) -> void:
	movement_input_state = vec


func jump_input(s : bool) -> void:
	jump_state = s


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if not was_on_floor:
			$WydawaczDzwiekow.push("landing")

	was_on_floor = is_on_floor()

	# Handle jump.
	if jump_state and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_state = false
		wydawacz_dzwiekow.say("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := movement_input_state
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var speed = BASE_SPEED
	if Input.is_action_pressed("move_speed"):
		speed *= SPEED_MULTIPLIER
	elif Input.is_action_pressed("move_crouch"):
		speed *= CROUCH_MULTIPLIER


	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			walk_integral += speed * delta
		else:
			velocity.x = move_toward(velocity.x, 0, BASE_SPEED)
			velocity.z = move_toward(velocity.z, 0, BASE_SPEED)
			walk_integral = 0.0
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * speed, AIRSTRAFE_SPEED)
			velocity.z = move_toward(velocity.z, direction.z * speed, AIRSTRAFE_SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, AIRSTRAFE_SPEED)
			velocity.z = move_toward(velocity.z, 0, AIRSTRAFE_SPEED)
		velocity += Vector3(1.0, 0.0, 1.0) *  direction * speed * delta * 0.6
		walk_integral = 0.0
	
	if Input.is_action_pressed("move_crouch"):
		scale = CROUCH_SCALE
	else:
		scale = BASE_SCALE
	
	if walk_integral > step_sound_threshold:
		$WydawaczDzwiekow.push("step")
		walk_integral -= step_sound_threshold

	move_and_slide()
