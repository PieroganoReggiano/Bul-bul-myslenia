extends Node3D

var moved_up : bool = false

const BASE_SPEED = 1.0

var spawn_point : float
var dst_point : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_point = $"Platform".position.y
	dst_point = spawn_point + 2.0

func Move_up() -> void:
	moved_up = true
	
func Move_down() -> void:
	moved_up = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var move_speed = BASE_SPEED * delta
	if moved_up:
		$"Platform".position.y = move_toward($"Platform".position.y, dst_point, move_speed)
	else:
		$"Platform".position.y = move_toward($"Platform".position.y, spawn_point, move_speed)
