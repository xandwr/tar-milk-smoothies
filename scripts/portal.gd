class_name Portal extends Node3D

enum PortalType {
	BLUE,
	ORANGE,
}

@export var other_portal: Portal = null
@export var portal_type: PortalType = PortalType.BLUE

@onready var portal_mesh: MeshInstance3D = %PortalMesh


func _ready() -> void:
	_update_visuals()


func _update_visuals() -> void:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	
	match portal_type:
		PortalType.BLUE: mat.albedo_color = Color.BLUE
		PortalType.ORANGE: mat.albedo_color = Color.ORANGE
		_: mat.albedo_color = Color.WHITE
	portal_mesh.material_override = mat


func _process(_delta: float) -> void:
	if other_portal:
		DebugDraw3D.draw_arrow(
			other_portal.global_position,
			other_portal.global_position - other_portal.global_transform.basis.z,
			Color.RED
		)
