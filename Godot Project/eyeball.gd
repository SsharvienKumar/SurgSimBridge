extends Node3D

@onready var iris_node := $iris

@export var rotation_scale := 0.8  # How sensitive the eye is

@export var pupil_scale_range := Vector2(1.5, 2.1) # adjust for sensitivity of scale
@export var iris_scale_range := Vector2(0.8, 1.2)

var min_pupil_width = 80.0
var max_pupil_width = 150.0
var min_pupil_height = 70.0
var max_pupil_height = 140.0
var min_iris_width = 100.0
var max_iris_width = 240.0
var min_iris_height = 90.0
var max_iris_height = 220.0



#func _ready():

#func set_ranges(ranges: Dictionary):
	#var iris = ranges["iris"]
	#min_iris_width = iris["min_width"]
	#max_iris_width = iris["max_width"]
	#min_iris_height = iris["min_height"]
	#max_iris_height = iris["max_height"]

	#var pupil = ranges["pupil"]
	#min_pupil_width = pupil["min_width"]
	#max_pupil_width = pupil["max_width"]
	#min_pupil_height = pupil["min_height"]
	#max_pupil_height = pupil["max_height"]

func process_data(data: Dictionary, video_width: int, video_height: int):
	if data.has("1"):  #use the entry with key "1"
		var iris = data["1"]
		#eye movement + global movement
		#if iris.has("centroid"):
			#var x = iris["centroid"][0]
			#var y = iris["centroid"][1]
#
			## Normalize pixel position to center of video frame
			#var norm_x = (x - video_width / 2.0) / video_width
			#var norm_y = (y - video_height / 2.0) / video_height
#
			## Rotate the eye: horizontal = Y, vertical = X
			#rotation.y = norm_x * rotation_scale
			#rotation.x = norm_y * rotation_scale
		#eyemovement - global movement
		if iris.has("centroid"):
			var x = iris["centroid"][0]
			var y = iris["centroid"][1]
			
			var gx = 0.0
			var gy = 0.0
			if data.has("global_mov"):
				gx = data["global_mov"][0]
				gy = data["global_mov"][1]
			
			var rel_x = x - gx
			var rel_y = y - gy

			var norm_x = rel_x / video_width
			var norm_y = rel_y / video_height

			rotation.y = norm_x * rotation_scale
			rotation.x = norm_y * rotation_scale

			
		# Iris full mesh scaling (size of eye)			
		if iris.has("length"):
			var length = iris["length"]
			var iris_height = length[0]  # vertical (Y)
			var iris_width = length[1]   # horizontal (X)

			# Normalize separately for width and height
			var t_x = clamp((iris_width - min_iris_width) / (max_iris_width - min_iris_width), 0.0, 1.0)
			var t_y = clamp((iris_height - min_iris_height) / (max_iris_height - min_iris_height), 0.0, 1.0)

			var scale_x = lerp(iris_scale_range.x, iris_scale_range.y, t_x)
			var scale_y = lerp(iris_scale_range.x, iris_scale_range.y, t_y)

			var base_scale = 0.75  # Tune this until the iris fits well
			iris_node.scale = Vector3(scale_x, scale_y, scale_y) * base_scale #z is x because depth is very small and otherwise it would be off, can also be y, just used as default
		
		#angle change with iris angle, should later add based on if one is missing, use pupil angle
		if iris.has("angle"):
			var angle = iris["angle"]
			var corrected_angle = -deg_to_rad(angle - 90.0)  # Subtract 90° to switch to major ellipse diameter, then negate to move clockwise
			iris_node.rotation.z = deg_to_rad(corrected_angle)
	
	# Pupil dilation inside iris mesh
	if data.has("2"):
		var pupil = data["2"]
		if pupil.has("length"):
			var length = pupil["length"]
			iris_node.call("set_pupil_scale_elliptical",
				length[1], length[0],  # pupil width and height from current frame
				min_pupil_width, max_pupil_width, min_pupil_height, max_pupil_height,
				pupil_scale_range)






func flinch_eye(offset := Vector3(0, -1, 0), return_delay := 0.1):
	print("flinch triggered")
	var original_rotation = rotation_degrees  # Save the current rotation
	rotation_degrees += offset              # Apply a quick jolt
	await get_tree().create_timer(return_delay).timeout  # Wait a short time
	rotation_degrees = original_rotation      # Snap back to normal
	
# To rotate 90 degrees around the Y axis, use this in your code:
#rotation_degrees = Vector3(0, 0, 90) # This is the correct way
#rotation = Vector3(0, 0, deg2rad(90)) # Or, use deg2rad() to convert degrees to radians

#func move_in_direction(target_rot: Vector3, speed := 5.0):
	#print("move triggered")
	#rotation_degrees = rotation_degrees.lerp(target_rot, speed * get_process_delta_time())



#@export var max_angle_deg := 25.0
#@export var smoothness := 5.0
#
#var target_rot := Vector3.ZERO
#
#func _process(delta):
	#var mouse_pos = get_viewport().get_mouse_position()
	#var screen_size = get_viewport().get_visible_rect().size
#
	#var norm_x = ((mouse_pos.x / screen_size.x) - 0.5) * 2
	#var norm_y = ((mouse_pos.y / screen_size.y) - 0.5) * 2
#
	## Angle Limit
	#var max_rad = deg_to_rad(max_angle_deg)
	#target_rot.x = clamp(-norm_y * max_rad, -max_rad, max_rad)
	#target_rot.y = clamp(norm_x * max_rad, -max_rad, max_rad)
#
	## Smooth movement: Linear interpolation
	#rotation.x = lerp(rotation.x, target_rot.x, delta * smoothness)
	#rotation.y = lerp(rotation.y, target_rot.y, delta * smoothness)
