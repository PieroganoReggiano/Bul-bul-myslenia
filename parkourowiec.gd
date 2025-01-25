class_name Parkourowiec
extends CharacterBody3D


const BASE_SPEED = 5.0
const AIRSTRAFE_SPEED = 0.15
const SPEED_MULTIPLIER = 1.5
const JUMP_VELOCITY = 3.0
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
var previous_position : Vector3

var movement_input_state := Vector2(0.0, 0.0)
var jump_state = false
var speed_state = true
var crouch_state = false

var choosen_bombel = 0
@export var naboj_scene: PackedScene = preload("res://sceny/sticky_bombel.tscn")
var walk_integral : float = 0.0
var step_sound_threshold : float = 1.0


func change_naboj():
	if choosen_bombel == 0:
		naboj_scene = preload("res://sceny/sticky_bombel.tscn")
	elif choosen_bombel == 1:
		naboj_scene = preload("res://sceny/antigravity_bombel.tscn")

func change_bombel(new_bombel):
	choosen_bombel = new_bombel
	change_naboj()

func shoot():
	if not naboj_scene:
		return
	
	# Tworzenie instancji naboju
	var naboj = naboj_scene.instantiate() as RigidBody3D
	
	# Ustawienie pozycji naboju na czubku guna
	# naboj.global_transform = gun_czubek.global_transform
	var head_basis = head.global_transform.basis
	naboj.global_position = head.global_position + head_basis * Vector3.FORWARD * 1.0
	
	# Dodanie naboju do sceny
	$"..".add_child(naboj)
	
	# Kierunek strzału (oparty na pozycji pistola)
	var world_direction = (gun_czubek.global_transform.origin - gun_base.global_transform.origin).normalized()
	# Nadanie prędkości naboju
	var speed = 40
	naboj.apply_impulse(world_direction * speed)

	$WydawaczDzwiekow.push("shoot")

	print("Kierunek strzału: ", world_direction * speed)



func rotate_input(r : Vector2) -> void:
	r *= 0.003
	# Obrót poziomy (oś Y)
	rotate_y(-r.x)

	# Obrót pionowy (oś X)
	vertical_rotation -= r.y
	vertical_rotation = clamp(vertical_rotation, -deg_to_rad(vertical_look_limit), deg_to_rad(vertical_look_limit))
	head.rotation.x = vertical_rotation


func move_input(vec : Vector2) -> void:
	movement_input_state = vec


func jump_input(s : bool) -> void:
	jump_state = s


func speed_input(s : bool) -> void:
	speed_state = s


func crouch_input(s : bool) -> void:
	crouch_state = s


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
	if speed_state:
		speed *= SPEED_MULTIPLIER
	elif crouch_state:
		speed *= CROUCH_MULTIPLIER


	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			var integral_diff : float = (position - previous_position).length() / sqrt(abs(speed))
			if not speed_state:
				integral_diff *= 0.6
				integral_diff -= walk_integral * (1.0 - pow(0.11, delta))
			walk_integral += integral_diff

		else:
			velocity.x = move_toward(velocity.x, 0, BASE_SPEED)
			velocity.z = move_toward(velocity.z, 0, BASE_SPEED)
			walk_integral = 0.0
	else:
		velocity += Vector3(1.0, 0.0, 1.0) *  direction * speed * delta * AIRSTRAFE_SPEED
		walk_integral = 0.0
	
	if crouch_state:
		scale = CROUCH_SCALE
	else:
		scale = BASE_SCALE
	
	if walk_integral > step_sound_threshold:
		$WydawaczDzwiekow.push("step")
		walk_integral -= step_sound_threshold

	previous_position = position

	move_and_slide()
