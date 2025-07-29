extends Camera3D

@export var camera_movement_scale := 8.0  # adjust to control sensitivity



# Called when the node enters the scene tree for the first time.
#func _ready():
	#set_process_input(true)

func update_camera(global_mov: Array, video_width: int, video_height: int):
	var global_x = global_mov[0]
	var global_y = global_mov[1]

	var norm_gx = (global_x - video_width / 2.0) / video_width #reference point, middle of screen
	var norm_gy = (global_y - video_height / 2.0) / video_height

	position.x = norm_gx * camera_movement_scale
	position.y = norm_gy * camera_movement_scale

#func _process(delta):
	#if Input.is_action_pressed("move_cam_forward"):
		#translate(Vector3.FORWARD)
	#if Input.is_action_pressed("move_cam_backward"):
		#translate(Vector3.BACK)
	#if Input.is_action_pressed("move_cam_left"):
		#translate(Vector3(-1.0, 0, 0))
	#if Input.is_action_pressed("move_cam_right"):
		#translate(Vector3(1.0, 0, 0))
