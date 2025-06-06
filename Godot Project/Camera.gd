extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func _process(delta):
	if Input.is_action_pressed("move_cam_forward"):
		translate(Vector3.FORWARD)
	if Input.is_action_pressed("move_cam_backward"):
		translate(Vector3.BACK)
	if Input.is_action_pressed("move_cam_left"):
		translate(Vector3(-1.0, 0, 0))
	if Input.is_action_pressed("move_cam_right"):
		translate(Vector3(1.0, 0, 0))
