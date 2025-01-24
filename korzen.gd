extends Node

@onready var swiat_contaiener : Node = $"SwiatContainer"
var default_swiat_scene = load("res://default_swiat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func clear_children(node : Node) -> void:
	var children = node.get_children()
	for c in children:
		node.remove_child(c)
		c.queue_free()



func reset_game() -> void:
	clear_children(swiat_contaiener)
	var swiat = default_swiat_scene.instantiate()
	swiat_contaiener.add_child(swiat)
	
