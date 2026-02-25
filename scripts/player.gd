extends RigidBody3D

@export var mouse_sensitivity: float = 0.33
@export var walk_speed: float = 3.5
@export var sprint_speed: float = 5.5
@export var jump_force: float = 4.0

@onready var head: Node3D = $Head
@onready var ground_cast: ShapeCast3D = $GroundCast

var mouse_locked: bool = true:
	set(value):
		mouse_locked = value
		_update_mouselock()
var pitch: float = 0.0
var yaw: float = 0.0
var move_speed: float = 0.0
var wish_dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	_update_mouselock()


func _update_mouselock() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_locked else Input.MOUSE_MODE_VISIBLE


func is_grounded() -> bool:
	if ground_cast and ground_cast.is_colliding():
		return true
	return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		mouse_locked = not mouse_locked
	
	if event is InputEventMouseMotion:
		pitch -= event.relative.y
		yaw -= event.relative.x


func _physics_process(delta: float) -> void:
	if head and mouse_locked:
		head.rotation.x = clampf(
			head.rotation.x + (pitch * delta * mouse_sensitivity),
			-PI / 2.0,
			PI / 2.0
		)
		rotation.y += yaw * delta * mouse_sensitivity
	
	pitch = 0.0
	yaw = 0.0
	
	if is_grounded() and Input.is_action_just_pressed("move_jump"):
		apply_impulse(Vector3(0, jump_force * mass, 0))
	
	wish_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_speed = sprint_speed if Input.is_action_pressed("move_sprint") else walk_speed
	
	var direction = (transform.basis * Vector3(wish_dir.x, 0.0, wish_dir.y)).normalized()
	var target_velocity = direction * move_speed
	var velocity_diff = target_velocity - Vector3(linear_velocity.x, 0.0, linear_velocity.z)
	apply_central_force(velocity_diff * mass * 32.0)
