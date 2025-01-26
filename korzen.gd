class_name Korzen
extends Node

@onready var swiat_container : Node = $"SwiatContainer"
@onready var menu = $GUI/Menu
@onready var hud = $GUI/HUD
@onready var przegranko = $GUI/Przegranko
@onready var gui = $GUI
var default_swiat_scene = load("res://sceny/level1.tscn")
var default_player = load("res://parkourowiec.tscn")

var current_player : Parkourowiec

@export var sensitivity : float = 2.0


var current_checkpoint : String = ""


func is_game() -> bool:
	return swiat_container and swiat_container.get_child_count() > 0


func go_to_menu() -> void:
	menu.show()
	hud.hide()
	przegranko.hide()
	refresh_mouse_visibility()


func go_to_game() -> void:
	menu.hide()
	hud.show()
	przegranko.hide()
	refresh_mouse_visibility()


func go_to_przegranko() -> void:
	przegranko.show()
	hud.hide()
	menu.hide()
	gui.lose = true
	gui.refresh()
	refresh_mouse_visibility()



func refresh_mouse_visibility() -> void:
	var hide = not menu.visible and not przegranko.visible
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
	current_checkpoint = ""
	clear_children(swiat_container)


func reset_game(checkpoint_name = "") -> void:
	drop_game()
	gui.lose = false
	var swiat = default_swiat_scene.instantiate()
	swiat_container.add_child(swiat)
	var spawn_node : Node3D = null
	if checkpoint_name != "":
		spawn_node = swiat.get_node_or_null(checkpoint_name)
	if not spawn_node:
		spawn_node = swiat.get_node_or_null("PlayerSpawn")
	var spawn_transform := Transform3D.IDENTITY
	if spawn_node:
		spawn_transform = spawn_node.transform
	var player = default_player.instantiate()
	swiat.add_child(player)
	player.position = spawn_transform.origin
	player.global_transform.basis = spawn_transform.basis
	select_player(player)


func revive() -> void:
	var chk = current_checkpoint
	gui.lose = false
	reset_game(chk)
	go_to_game()


func play() -> void:
	if not is_game():
		reset_game()
	else:
		# TODO unpause
		pass


func _physics_process(_delta) -> void:
	if current_player and current_player.defeated:
		go_to_przegranko()


func force_defeat() -> void:
	if current_player:
		current_player.defeat()


func _input(event) -> void:
	if not menu.visible:
		if current_player and not current_player.defeated:
			if event is InputEventMouseMotion:
				current_player.rotate_input(event.relative * sensitivity)
			elif event.is_action_pressed("shoot"):
				current_player.shoot()
			elif event.is_action_pressed("antishoot"):
				current_player.antishoot()
			elif event.is_action_released("antishoot"):
				current_player.stop_antishoot()
			elif event.is_action_pressed("move_jump"):
				current_player.jump_input(true)
			elif event.is_action_released("move_jump"):
				current_player.jump_input(false)
			elif event.is_action_pressed("move_speed"):
				current_player.speed_input(false)
			elif event.is_action_released("move_speed"):
				current_player.speed_input(true)
			elif event.is_action_pressed("move_crouch"):
				current_player.crouch_input(true)
			elif event.is_action_released("move_crouch"):
				current_player.crouch_input(false)
			elif event.is_action_pressed("defeat"):
				force_defeat()
			elif event.is_action_pressed("look_at_gun"):
				current_player.look_at_gun()
			else:
				for i in range(3):
					if event.is_action_pressed("skill_%s" % i):
						current_player.change_bombel(i)
						break
			var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
			current_player.move_input(input_dir)


func check(point : Checkpoint, parkourowiec : Parkourowiec) -> bool:
	if parkourowiec == current_player and point.name.casecmp_to(current_checkpoint) > 0:
		current_checkpoint = point.name
		return true
	return false


func get_checkpoint_color(point : Checkpoint) -> Color:
	print(current_checkpoint)
	if point.name == current_checkpoint:
		return Color.BLUE
	elif point.name.casecmp_to(current_checkpoint) > 0:
		return Color(0.99, 0.1, 0.0)
	else:
		return Color.TRANSPARENT
