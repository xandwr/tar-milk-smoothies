class_name MassGun extends Node3D

## How far the gun can reach.
@export var reach: float = 20.0
## Mass drained/filled per second while holding the trigger.
@export var transfer_rate: float = 10.0
## Maximum energy the backpack tank can hold.
@export var tank_capacity: float = 100.0
## Minimum mass an object can be drained to.
@export var min_object_mass: float = 0.5

@onready var camera: Camera3D = get_viewport().get_camera_3d()

var tank: float = 0.0
var target: RigidBody3D = null
var target_original_mass: float = 0.0
var target_original_scale: Vector3 = Vector3.ONE


func _physics_process(delta: float) -> void:
	_update_target()

	if target:
		if Input.is_action_pressed("mass_drain"):
			_drain(delta)
		elif Input.is_action_pressed("mass_fill"):
			_fill(delta)


func _update_target() -> void:
	if not camera:
		camera = get_viewport().get_camera_3d()
		return

	var from = camera.global_position
	var to = from + -camera.global_basis.z * reach
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result and result.collider is RigidBody3D:
		var hit = result.collider as RigidBody3D
		if hit != target:
			target = hit
			target_original_mass = hit.mass
			target_original_scale = hit.scale
	else:
		target = null


func _drain(delta: float) -> void:
	var amount = transfer_rate * delta
	var available = target.mass - min_object_mass
	amount = minf(amount, available)
	amount = minf(amount, tank_capacity - tank)

	if amount <= 0.0:
		return

	target.mass -= amount
	tank += amount
	_update_object_scale(target)


func _fill(delta: float) -> void:
	var amount = transfer_rate * delta
	amount = minf(amount, tank)

	if amount <= 0.0:
		return

	target.mass += amount
	tank -= amount
	_update_object_scale(target)


func _update_object_scale(body: RigidBody3D) -> void:
	var mass_ratio = body.mass / target_original_mass
	body.scale = target_original_scale * mass_ratio
