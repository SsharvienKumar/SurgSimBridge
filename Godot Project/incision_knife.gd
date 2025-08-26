extends MeshInstance3D

@onready var camera = $"../Camera3D"

@export var incknife_position_offset := Vector3(0.0, -0.5, 0) # match where incision knife starts
@export var tool_depth := 19.0 # z-distance from camera
#var og_position = position
#var og_rotation = rotation

func _ready():
	var center_pos = camera.position + camera.camera_position_offset
	incknife_position_offset.z = center_pos.z - tool_depth


func update_incknife(incknife: Dictionary, video_width: int, video_height: int):
	if incknife.has("tip"):
		visible = true
		var tip_x = incknife["tip"][0]
		var tip_y = incknife["tip"][1]

		var norm_tx = (tip_x - video_width / 2.0) / video_width #reference point, middle of screen
		var norm_ty = (-tip_y + video_height / 2.0) / video_height #inverted since data is inverted
	
		position.x = norm_tx * camera.camera_movement_scale + incknife_position_offset.x #camera.camera_position_offset.x#
		position.y = norm_ty * camera.camera_movement_scale + incknife_position_offset.y #camera.camera_position_offset.y#
		position.z = incknife_position_offset.z  # keep locked in place in front of camera
	else:
		visible = false
		
	if incknife.has("angle"):
		#var angle = deg_to_rad(incknife["angle"])
		#rotation.x = lerp(rotation.x, angle, 0.8)  # smooth
		var angle = incknife["angle"]
		rotation.x = deg_to_rad(angle)
