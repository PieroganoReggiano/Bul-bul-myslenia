class_name Korzen
extends Node

@onready var swiat_container : Node = $"SwiatContainer"
@onready var menu = $GUI/Menu
var default_swiat_scene = load("res://sceny/arena_1.tscn")
var default_player = load("res://parkourowiec.tscn")

var current_player : Parkourowiec

@export var sensitivity : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func go_to_menu() -> void:
	menu.show()
	refresh_mouse_visibility()


func go_to_game() -> void:
	menu.hide()
	refresh_mouse_visibility()


func refresh_mouse_visibility() -> void:
	var hide = not menu.visible
	if hide:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func clear_children(node : Node) -> void:
	var children = node.get_children()
	for c in children:
		node.remove_child(c)
		c.queue_free()


func select_player(who : Parkourowiec) -> void:
	current_player = who
	var camera : Camera3D = who.get_node("Glowa/Camera3D")
	camera.make_current()


func drop_game() -> void:
	current_player = null
	clear_children(swiat_container)


func reset_game() -> void:
	drop_game()
	var swiat = default_swiat_scene.instantiate()
	swiat_container.add_child(swiat)
	var spawn_node : Node3D = swiat.get_node_or_null("PlayerSpawn")
	var spawn_point := Vector3(0.0, 0.0, 0.0)
	if spawn_node:
		spawn_point = spawn_node.position
	var player = default_player.instantiate()
	swiat.add_child(player)
	player.position = spawn_point
	select_player(player)


func play() -> void:
	if swiat_container.get_child_count() < 1:
		reset_game()
	else:
		# TODO unpause
		pass


func _input(event) -> void:
	if not menu.visible:
		if current_player:
			if event is InputEventMouseMotion:
				current_player.rotate_input(event.relative * sensitivity)
			elif event.is_action_pressed("shoot"):
				current_player.shoot()
			elif event.is_action_pressed("move_jump"):
				current_player.jump_input(true)
			elif event.is_action_released("move_jump"):
				current_player.jump_input(false)
			var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
			current_player.move_input(input_dir)
