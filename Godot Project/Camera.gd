extends Camera3D

@export var camera_movement_scale := 10.0#0.5  # adjust to control sensitivity
@export var camera_position_offset := Vector3(0.0, 0.0, 0.0) # match where eye starts
@export var camera_rotation_offset := Vector3(0, 0.01, 0) # match where eye starts
var og_position = position
var og_rotation = rotation
# Called when the node enters the scene tree for the first time.
#func _ready():
	#set_process_input(true)

func update_camera(global_mov: Array, video_width: int, video_height: int):
	var global_x = global_mov[0]
	var global_y = global_mov[1]

	var norm_gx = (global_x - video_width / 2.0) / video_width #reference point, middle of screen
	var norm_gy = (global_y - video_height / 2.0) / video_height
	
	#rotation.x = norm_gx * camera_movement_scale
	#rotation.y = norm_gy * camera_movement_scale
	
	position.x = norm_gx * camera_movement_scale + camera_position_offset.x
	position.y = norm_gy * camera_movement_scale + camera_position_offset.y
	#position.z = og_position.z + camera_position_offset.z
	#rotation.y = og_rotation.y + camera_rotationn_offset.y
	#position.x =  camera_position_offset.x
	#position.y =  camera_position_offset.y

#func _process(delta):
	#if Input.is_action_pressed("move_cam_forward"):
		#translate(Vector3.FORWARD)
	#if Input.is_action_pressed("move_cam_backward"):
		#translate(Vector3.BACK)
	#if Input.is_action_pressed("move_cam_left"):
		#translate(Vector3(-1.0, 0, 0))
	#if Input.is_action_pressed("move_cam_right"):
		#translate(Vector3(1.0, 0, 0))
