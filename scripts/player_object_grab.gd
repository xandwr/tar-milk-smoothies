class_name PlayerObjectGrab extends Node3D

@export var max_grab_mass: float = 12.5
@export var hold_distance: float = 2.0
@export var grab_strength: float = 4.0

@onready var grab_cast: RayCast3D = $GrabCast

var held_object: RigidBody3D = null


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if held_object:
			_drop()
			return

		if grab_cast and grab_cast.is_colliding():
			var c = grab_cast.get_collider()
			if c is RigidBody3D and c.mass <= max_grab_mass:
				held_object = c
				held_object.gravity_scale = 0.0

	if held_object:
		if held_object.mass > max_grab_mass:
			_drop()
			return

		var mass_ratio = held_object.mass / max_grab_mass
		var strength = lerpf(grab_strength, grab_strength * 0.1, mass_ratio)
		var hold_pos = global_position + -global_basis.z * hold_distance
		var offset = hold_pos - held_object.global_position
		held_object.linear_velocity = offset * strength


func _drop() -> void:
	if held_object:
		held_object.gravity_scale = 1.0
		held_object = null
