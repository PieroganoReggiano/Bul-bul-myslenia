class_name Parkourowiec
extends CharacterBody3D


const BASE_SPEED = 5.0
const AIRSTRAFE_SPEED = 0.8
const SPEED_MULTIPLIER = 1.5
const JUMP_VELOCITY = 4.2
const CROUCH_MULTIPLIER = 0.5

const BASE_SCALE = Vector3(1, 1, 1)
const CROUCH_SCALE = Vector3(1, 0.5, 1)

@onready var camera: Camera3D = $Glowa/Camera3D
@onready var head: Node3D = $Glowa
@onready var gun: Node3D = $Glowa/Gun
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
var defeated : bool = false

var choosen_bombel = 0
@export var naboj_scene: PackedScene = preload("res://sceny/sticky_bombel.tscn")
var walk_integral : float = 0.0
var step_sound_threshold : float = 1.0


var move_time : float = 0.0
var machanie_intensity : float = 0.0


func defeat() -> void:
	defeated = true


func change_bombel(new_bombel):
	gun.choose(new_bombel)

func shoot():
	# Ustawienie pozycji naboju na czubku guna
	# naboj.global_transform = gun_czubek.global_transform
	var head_basis = head.global_transform.basis
	var origin = head.global_position + head_basis * Vector3.FORWARD * 2.0
	var world_direction = (gun_czubek.global_transform.origin - gun_base.global_transform.origin).normalized()

	gun.shoot(origin, world_direction)


func antishoot():
	# Ustawienie pozycji naboju na czubku guna
	# naboj.global_transform = gun_czubek.global_transform
	var head_basis = head.global_transform.basis
	var origin = head.global_position + head_basis * Vector3.FORWARD * 2.0
	var world_direction = (gun_czubek.global_transform.origin - gun_base.global_transform.origin).normalized()

	gun.antishoot(origin, world_direction)


func stop_antishoot():
	gun.stop_antishoot()


func rotate_input(r : Vector2) -> void:
	if defeated:
		return
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

	if defeated:
		return

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
	if crouch_state:
		speed *= CROUCH_MULTIPLIER
	elif speed_state:
		speed *= SPEED_MULTIPLIER


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

	var new_intensity = min(2.0, (position - previous_position).length() / delta * 0.0067)
	machanie_intensity = lerpf(machanie_intensity, new_intensity, 0.062)
	var sinus = machanie_intensity * sin(move_time * 4.5)
	var cosinus = machanie_intensity * cos(move_time * 4.5)
	move_time += delta * (0.7 + 2.0 * machanie_intensity)

	previous_position = position

	gun.get_node("gan plyn").position.z = clamp(sinus, -0.1, 0.04)
	gun.get_node("gan plyn").position.x = clamp(cosinus, -0.1, 0.1) * 0.2
	move_and_slide()


func look_at_gun() -> void:
	$AnimationPlayer.play("look_at_gun")
