extends Node3D

@export var max_speed: float = 7.0
@export var jump_velocity: float = 5.0
@export var ground_accel: float = 10.0
@export var air_accel: float = 1.5
@export var ground_friction: float = 8.0

var character_body: CharacterBody3D
var move_dir: Vector3

func _ready() -> void:
	character_body = get_parent()

func _physics_process(delta: float) -> void:
	if not character_body.is_on_floor():
		character_body.velocity += character_body.get_gravity() * delta
		_accelerate(move_dir, air_accel, delta)
	else:
		_apply_friction(delta)
		_accelerate(move_dir, ground_accel, delta)

	character_body.move_and_slide()
	
func _set_move_dir(new_move_dir: Vector3) -> void:
	move_dir = new_move_dir

func _jump() -> void:
	if character_body.is_on_floor():
		character_body.velocity.y = jump_velocity
		
func _accelerate(wish_dir: Vector3, accel: float, delta: float) -> void:
	var current_speed := character_body.velocity.dot(wish_dir)
	var add_speed := max_speed - current_speed
	if add_speed <= 0.0:
		return
	var accel_speed = min(accel * max_speed * delta, add_speed)
	character_body.velocity.x += wish_dir.x * accel_speed
	character_body.velocity.z += wish_dir.z * accel_speed

func _apply_friction(delta: float) -> void:
	var horizontal := Vector2(character_body.velocity.x, character_body.velocity.z)
	var speed := horizontal.length()
	if speed < 0.001:
		character_body.velocity.x = 0.0
		character_body.velocity.z = 0.0
		return
	var drop = speed * ground_friction * delta
	var scale = max(speed - drop, 0.0) / speed
	character_body.velocity.x *= scale
	character_body.velocity.z *= scale
