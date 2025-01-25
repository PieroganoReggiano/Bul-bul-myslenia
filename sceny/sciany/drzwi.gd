extends Node3D

var opened : bool = false

const BASE_SPEED = 1.0

var left_wing_spawn_point : float
var right_wing_spawn_point : float
var left_wing_dst_point : float
var right_wing_dst_point : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_wing_spawn_point = $"Left wing".position.x
	right_wing_spawn_point = $"Right wing".position.x
	
	left_wing_dst_point = left_wing_spawn_point + 2.0
	right_wing_dst_point = right_wing_spawn_point + -2.0
	pass # Replace with function body.

func Open_door() -> void:
	print("Door opened")
	opened = true
	pass
	
func Close_door() -> void:
	print("Door closed")
	opened = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var move_speed = BASE_SPEED * delta
	if opened:
		$"Left wing".position.x = move_toward($"Left wing".position.x, left_wing_dst_point, move_speed)
		$"Right wing".position.x = move_toward($"Right wing".position.x, right_wing_dst_point, move_speed)
	else:
		$"Left wing".position.x = move_toward($"Left wing".position.x, left_wing_spawn_point, move_speed)
		$"Right wing".position.x = move_toward($"Right wing".position.x, right_wing_spawn_point, move_speed)
