class_name BubblePurple
extends RigidBody3D

#var volume : float = 100.0
@export var volume_level = 1
@export var inflating : bool = false
const default_radius = 1.0
const default_block_radius = 0.94
const pop_radius = 8.0
@onready var mesh = $MeshInstance3D


var time_elapsed = 0.0
var no_pop_sound := false


func get_volume() -> float:
	match volume_level:
		1: return 86.0
		2: return 500.0
		3: return 2400.0
		_: return 100.0


func calc_scale() -> float:
	return pow(get_volume(), 1.0/3.0) / PI * 3 / 4


func refresh_scale(delta: float) -> void:
	var s = calc_scale()
	$CollisionShape3D.shape.radius = default_block_radius * s - 0.16
	$PushArea/CollisionShape3D.shape.radius = default_radius * s
	$StickArea/CollisionShape3D.shape.radius = default_radius * s * 0.72
	mesh.scale = Vector3.ONE * s * 2.0


func _ready() -> void:
	refresh_scale(0)


func _physics_process(delta: float) -> void:
	refresh_scale(delta)
	time_elapsed += delta
	if not freeze:
		if time_elapsed >= 8.0:
			queue_free()


func _on_push_area_area_entered(area: Area3D) -> void:
	var o = area.get_parent()
	if o is BubblePurple:
		merge(area.get_parent())
		return


func _on_stickarea_body_entered(body: Node) -> void:
	freeze = true
	$WydawaczDzwiekow.push("stick")



func merge(o : BubblePurple) -> void:
	if o.volume_level > volume_level:
		return
	elif o.volume_level == volume_level:
		if o.get_rid() > get_rid():
			return
	
	merge_internal(self, o)


func _on_tree_exiting() -> void:
	if no_pop_sound:
		return
	$WydawaczDzwiekow.push("pop", true)


static func merge_internal(one : BubblePurple, two : BubblePurple):	
	if (one.volume_level >= 3):
		two.queue_free()
		return
	assert(two.volume_level < 3)
	var level = one.volume_level + two.volume_level
	level = min(3, level)
	var vol1 = one.get_volume()
	var vol2 = two.get_volume()
	var new_position = lerp(one.position, two.position, vol1 / (vol1 + vol2))
	one.volume_level = level
	one.position = new_position
	two.no_pop_sound = true
	two.queue_free()
	one.get_node("WydawaczDzwiekow").push("merge")
