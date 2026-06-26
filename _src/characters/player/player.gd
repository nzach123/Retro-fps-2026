extends CharacterBody3D

@export var camera_3d : Camera3D 
@export var character_mover: Node3D 
@export var health_manager: Node3D
@export var h_sensitivity: float = 0.003
@export var v_sensitivity: float = 0.003
@onready var weapon_manager: Node3D = $Camera3D/WeaponManager


const HOTKEYS = {
	KEY_1:0,
	KEY_2:1,
	KEY_3:2,
	KEY_4:3,
	KEY_5:4,
	KEY_6:5,
	KEY_7:6,
	KEY_8:7,
	KEY_9:8,
	KEY_0:9,
	}

var dead: bool = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_manager.died.connect(kill)

func _input(event: InputEvent):
		if dead:
			return
		if event is InputEventMouseMotion:
			# Rotation_degrees can cause gimbal lock, 
			# Safer to manipulate radians using rotate_y and rotate_object_local
			rotate_y(-event.relative.x * h_sensitivity)
			camera_3d.rotate_x(-event.relative.y * v_sensitivity)
			camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				weapon_manager.switch_to_previews_weapon()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				weapon_manager.switch_to_next_weapon()
		if event is InputEventKey and event.pressed and event.keycode in HOTKEYS:
			weapon_manager.switch_to_weapons_slot(HOTKEYS[event.keycode])
					
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
	
	# Run jump function from character_move when "jump" input is pressed.
	if Input.is_action_just_pressed("jump"):
		character_mover._jump()
	if dead:
		return
	# Gets the movement vectors to determine the player direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	character_mover._set_move_dir(move_dir)
	
# Controls what happens when the player dies.	
func kill():
	dead = true
	# Stops the player from moving
	character_mover._set_move_dir(Vector3.ZERO)
