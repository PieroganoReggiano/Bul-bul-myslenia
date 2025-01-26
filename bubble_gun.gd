extends Node3D


@export var colour : Color = Color("fcc200")

@onready var plyn := $"gan plyn/Armature/Skeleton3D/Plyn"

const colours : Array[Color] = [
	Color("fcc200"),
	Color.BLUE,
	Color.MAGENTA,
]


func choose(c : int) -> void:
	if c < 0 or c >= colours.size():
		c = 0
	colour = colours[c]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var sm := plyn.get_surface_override_material(0) as ShaderMaterial
	sm.set_shader_parameter("ColorParameter", Color.WHITE)
	sm.set_shader_parameter("ColorParameter2", colour)
