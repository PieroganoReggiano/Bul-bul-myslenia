extends Node3D


@export var colour : Color = Color("fcc200")

@onready var plyn := $"gan plyn/Armature/Skeleton3D/Plyn"

var choice : int = 0
var jammed : bool = false
var clear_channelling = false
var channel_time : float = 0.0

const colours : Array[Color] = [
	Color("fcc200"),
	Color.BLUE,
	Color.MAGENTA,
]


const bullets : Array[Resource] = [
	preload("res://sceny/sticky_bombel.tscn"),
	preload("res://sceny/antigravity_bombel.tscn"),
	preload("res://sceny/bubble_purple.tscn"),
]


const full_ammo : Array[int] = [ 12, 4, 6 ]
var current_ammo : Array[int] = [ 0, 0, 0 ]

var current_bubbles : Array[Node3D] = []


func _physics_process(delta : float) -> void:
	for i in current_ammo.size():
		current_ammo[i] = full_ammo[i]
	var i := current_bubbles.size() - 1
	while i >= 0:
		if not current_bubbles[i]:
			current_bubbles.remove_at(i)
		i -= 1
	i = 0
	while i < current_bubbles.size():
		var bubble = current_bubbles[i]
		if bubble is OrangeBubble:
			current_ammo[0] -= bubble.volume_level
		elif bubble is BlueBubble:
			current_ammo[1] -= 1
		i += 1
	
	if get_ammo(choice) <= 0:
		$"gan plyn/Armature/Skeleton3D/Plyn".hide()
	else:
		$"gan plyn/Armature/Skeleton3D/Plyn".show()
		
	if clear_channelling:
		channel_time += delta
		if channel_time >= 2.0:
			channel_time = 0.0
			clear_channelling = false
			clear_colour()


func choose(c : int) -> void:
	if choice != c:
		clear_channelling = false
		channel_time = 0.0
	choice = c
	if c < 0 or c >= colours.size():
		c = 0
	colour = colours[c]


func get_ammo(which : int) -> int:
	return current_ammo[which]


func shoot(origin : Vector3, direction : Vector3) -> void:
	var index = clamp(choice, 0, bullets.size() - 1)
	if get_ammo(index) <= 0 or jammed:
		return
	var bullet_scene = bullets[index]
	var bullet = bullet_scene.instantiate() as RigidBody3D
	var world = SwiatContainer.get_world(self)
	world.add_child(bullet)

	bullet.global_position = origin
	var speed = 40.0
	direction = direction.normalized()
	bullet.apply_impulse(direction * speed)
	$WydawaczDzwiekow.push("shoot")
	$"gan plyn/AnimationPlayer".play("Gun_Shoot", -1, 1.5)
	jammed = true
	current_bubbles.append(bullet)


func antishoot(origin : Vector3, direction : Vector3) -> void:
	clear_channelling = true
	var index = clamp(choice, 0, bullets.size() - 1)


func stop_antishoot() -> void:
	clear_channelling = false


func clear_colour() -> void:
	var i := current_bubbles.size() - 1
	var cleared : int = 0
	while i >= 0:
		var bubble = current_bubbles[i]
		if bubble:
			if bubble is OrangeBubble and choice == 0:
				bubble.queue_free()
				cleared += 1
			if bubble is BlueBubble and choice == 1:
				bubble.queue_free()
				cleared += 1
			if bubble is BubblePurple and choice == 2:
				bubble.queue_free()
				cleared += 1
		i -= 1
	i = 0
	if cleared > 0:
		$WydawaczDzwiekow.push("clear")


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var sm := plyn.get_surface_override_material(0) as ShaderMaterial
	sm.set_shader_parameter("ColorParameter", Color.WHITE)
	sm.set_shader_parameter("ColorParameter2", colour)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	jammed = false
