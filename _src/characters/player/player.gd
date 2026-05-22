extends CharacterBody3D

@export var camera_3d : Camera3D 
@export var character_mover: Node3D 

@export var h_sensitivity: float = 0.003
@export var v_sensitivity: float = 0.003



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent):
		if event is InputEventMouseMotion:
			# Rotation_degrees can cause gimbal lock, 
			# Safer to manipulate radians using rotate_y and rotate_object_local
			rotate_y(-event.relative.x * h_sensitivity)
			camera_3d.rotate_x(-event.relative.y * v_sensitivity)
			camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			
		if Input.is_action_just_pressed("quit"):
			get_tree().quit()
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		if Input.is_action_just_pressed("fullscreen"):
			var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
			if fs:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
				
			
func _physics_process(delta: float) -> void:
	

	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
		

	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	character_mover.set_move_dir(move_dir)
	
