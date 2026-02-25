class_name Portal extends Node3D

enum PortalType {
	BLUE,
	ORANGE,
}

@export var other_portal: Portal = null
@export var portal_type: PortalType = PortalType.BLUE

@onready var portal_mesh: MeshInstance3D = %PortalMesh
@onready var render_mesh: MeshInstance3D = %RenderMesh
@onready var portal_camera: Camera3D = %PortalCamera


var _render_mat_set := false


func _ready() -> void:
	PortalManager.register(self)
	_update_portal_color()


func _exit_tree() -> void:
	PortalManager.unregister(self)


func get_linked() -> Portal:
	return PortalManager.get_linked(self)


func _update_portal_color() -> void:
	var portal_mat := StandardMaterial3D.new()
	match portal_type:
		PortalType.BLUE: portal_mat.albedo_color = Color.BLUE
		PortalType.ORANGE: portal_mat.albedo_color = Color.ORANGE
		_: portal_mat.albedo_color = Color.WHITE
	portal_mesh.material_override = portal_mat


func _update_render_texture() -> void:
	if _render_mat_set:
		return
	var linked = get_linked()
	if not linked or not linked.portal_camera:
		return
	var vp = linked.portal_camera.get_parent() as SubViewport
	if not vp:
		return
	var render_mat := StandardMaterial3D.new()
	render_mat.albedo_texture = vp.get_texture()
	render_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	render_mesh.material_override = render_mat
	_render_mat_set = true


func _process(_delta: float) -> void:
	_update_render_texture()
	var linked = get_linked()
	if not linked or not PortalManager.player_camera: return
	
	# This camera's output is shown on the linked portal's screen.
	# The linked portal should show what's on the other side of THIS portal.
	# Get player offset from linked portal, flip 180 so camera faces outward
	# (behind the portal surface), then apply at this portal.
	var player_cam = PortalManager.player_camera
	var relative_to_linked = linked.global_transform.affine_inverse() * player_cam.global_transform
	# Negate Z position (put camera behind portal) and rotate 180 around Y (face outward)
	relative_to_linked.origin.z = -relative_to_linked.origin.z
	relative_to_linked.origin.x = -relative_to_linked.origin.x
	relative_to_linked = relative_to_linked.rotated_local(Vector3.UP, PI)
	portal_camera.global_transform = global_transform * relative_to_linked
