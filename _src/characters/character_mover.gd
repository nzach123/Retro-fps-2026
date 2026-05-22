extends Node3D


@export var max_speed = 5.0
@export var jump_velocity = 4.5
@export var move_accel = 4.0
@export var stop_drag = 0.9

var character_body = CharacterBody3D
var move_drag = 0.0
var move_dir : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	character_body = get_parent()
	move_drag = float(move_accel) / max_speed

func set_move_dir(new_move_dir: Vector3):
	move_dir = new_move_dir
	
func jump() -> void:
	if character_body.is_on_floor():
		character_body.velocity.y = jump_velocity
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var drag = move_drag
	
	if not character_body.is_on_floor():
		character_body.velocity += character_body.get_gravity() * delta
	if move_dir:
		character_body.velocity.x = move_dir.x * max_speed
		character_body.velocity.z = move_dir.z * max_speed

	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, max_speed)
		character_body.velocity.z = move_toward(character_body.velocity.z, 0, max_speed)	


	character_body.move_and_slide()
