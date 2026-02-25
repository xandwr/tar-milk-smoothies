extends RigidBody3D

@export var mouse_sensitivity: float = 0.33

@onready var head: Node3D = $Head

var mouse_locked: bool = true:
	set(value):
		mouse_locked = value
		_update_mouselock()
var pitch: float = 0.0
var yaw: float = 0.0


func _ready() -> void:
	_update_mouselock()


func _update_mouselock() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_locked else Input.MOUSE_MODE_VISIBLE


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		mouse_locked = not mouse_locked
	
	if event is InputEventMouseMotion:
		pitch -= event.relative.y
		yaw -= event.relative.x


func _process(delta: float) -> void:
	if head and mouse_locked:
		head.rotation.x = clampf(
			head.rotation.x + (pitch * delta * mouse_sensitivity),
			-PI / 2.0,
			PI / 2.0
		)
		rotation.y += yaw * delta * mouse_sensitivity
	
	pitch = 0.0
	yaw = 0.0
