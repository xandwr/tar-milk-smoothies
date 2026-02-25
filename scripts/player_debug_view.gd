class_name PlayerDebugView extends Node


func _process(_delta: float) -> void:
	for node in _get_all_rigid_bodies(get_tree().root):
		DebugDraw3D.draw_text(node.global_position + (Vector3.UP * 1.5), "Mass: %.2f" % node.mass)


func _get_all_rigid_bodies(root: Node) -> Array[RigidBody3D]:
	var result: Array[RigidBody3D] = []
	for child in root.get_children():
		if child is RigidBody3D:
			result.append(child)
		result.append_array(_get_all_rigid_bodies(child))
	return result
