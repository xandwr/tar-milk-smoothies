extends CharacterBody3D

@export var mouse_sensitivity: float = 0.33
@export var walk_speed: float = 3.5
@export var sprint_speed: float = 5.5
@export var jump_force: float = 4.0
@export var acceleration: float = 32.0
@export var air_acceleration: float = 4.0

@onready var head: Node3D = $Head

var mouse_locked: bool = true:
	set(value):
		mouse_locked = value
		_update_mouselock()
var pitch: float = 0.0
var yaw: float = 0.0
var external_velocity: Vector3 = Vector3.ZERO


func _ready() -> void:
	PortalManager.player = self
	PortalManager.player_camera = $Head/Camera3D
	_update_mouselock()


func _update_mouselock() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_locked else Input.MOUSE_MODE_VISIBLE


func apply_impulse(impulse: Vector3) -> void:
	external_velocity += impulse


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		mouse_locked = not mouse_locked

	if event is InputEventMouseMotion:
		pitch -= event.relative.y
		yaw -= event.relative.x


func _physics_process(delta: float) -> void:
	if head and mouse_locked:
		head.rotation.x = clampf(head.rotation.x + (pitch * delta * mouse_sensitivity), -PI / 2.0, PI / 2.0)
		rotation.y += yaw * delta * mouse_sensitivity
	pitch = 0.0
	yaw = 0.0

	if not is_on_floor(): velocity.y += get_gravity().y * delta
	if is_on_floor() and Input.is_action_just_pressed("move_jump"): velocity.y = jump_force

	var wish_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_speed = sprint_speed if Input.is_action_pressed("move_sprint") else walk_speed
	var direction = (transform.basis * Vector3(wish_dir.x, 0.0, wish_dir.y)).normalized()
	var target = direction * move_speed
	var accel = acceleration if is_on_floor() else air_acceleration

	velocity.x = move_toward(velocity.x, target.x, accel * delta)
	velocity.z = move_toward(velocity.z, target.z, accel * delta)

	velocity += external_velocity
	external_velocity = Vector3.ZERO

	move_and_slide()
