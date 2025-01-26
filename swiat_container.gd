class_name SwiatContainer
extends Node

static func get_world(node : Node) -> Node3D:
	while node != null and not node is SwiatContainer:
		node = node.get_parent()
	if node == null:
		return null
	return node.get_child(0)
