extends Node3D

@onready var iris_node := $iris

@export var global_scale := 1.0 #%switch 10.0
@export var rotation_scale_x := 1.0
@export var rotation_scale_y := 0.59  # How sensitive the eye is#%switch 1.5
@export var eye_rotation_offset := Vector2(deg_to_rad(0.0), deg_to_rad(0.0)) #adjust to fit eye

@export var pupil_scale_range := Vector2(1.5, 2.2) # adjust for sensitivity of scale
@export var iris_scale_range := Vector2(0.5, 1.3)

var min_pupil_width = 110.0#114.96
var max_pupil_width = 150.0#145.77
var min_pupil_height = 80.0# 85.58#
var max_pupil_height = 120.0#111.6#
var min_iris_width = 100.0#187.05#
var max_iris_width = 240.0#246.99#
var min_iris_height = 90.0#126.34#
var max_iris_height = 220.0#154.2#



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
	#if data.has("global_mov"):
		#var gx = data["global_mov"][0] 
		#var gy = data["global_mov"][1]
		#
		#var norm_gx = (gx - video_width / 2.0) / video_width #reference point, middle of screen
		#var norm_gy = (-gy + video_height / 2.0) / video_height  #inverted since data is inverted
		#
		#position.x = norm_gx * global_scale 
		#position.y = norm_gy * global_scale
		#
	if data.has("1"):  #use the entry with key "1"
		var iris = data["1"]
		#eye movement + global movement
		if iris.has("centroid"):
			var x = iris["centroid"][0]
			var y = iris["centroid"][1]
#
			# Normalize pixel position to center of video frame
			var norm_x = (x - video_width / 2.0) / (video_width / 2.0) * (video_width/video_height) #now ranges from +1 to -1
			var norm_y = (y - video_height / 2.0) / (video_height / 2.0)

			# Rotate the eye: horizontal = Y, vertical = X for godot
			#rotation.y = norm_x * rotation_scale_y
			#rotation.x = norm_y * rotation_scale_y
			var angle_x = 0
			var angle_y = 0
			angle_x = atan(norm_y * rotation_scale_y)  # vertical centroid -> pitch (rotation.x) 
			angle_y = atan(norm_x * rotation_scale_y)  # vertical centroid -> pitch (rotation.x) 
			rotation.x = angle_x
			rotation.y = angle_y
			# navigation
			#position.x = norm_gx * global_scale 
			#position.y = norm_y * global_scale
			
			
			# circular normalization
			## Step 1: recenter around video middle
			#var dx = x - video_width / 2.0
			#var dy = y - video_height / 2.0
#
			## Step 2: scale separately by half-width/half-height
			#var nx = dx / (video_width / 2.0)
			#var ny = dy / (video_height / 2.0)
#
			## Now nx, ny ∈ [-1,1] but distorted (ellipse if you plot it)
#
			## Step 3: normalize into a circle
			#var r = sqrt(nx*nx + ny*ny)
			#if r > 1.0:
				#nx /= r
				#ny /= r
#
			## Result: (nx, ny) is inside a unit circle
			## Step 4: scale to eyeball rotation
			#rotation.y = nx * rotation_scale_y
			#rotation.x = ny * rotation_scale_x

		#eyemovement - global movement
		#if iris.has("centroid"):
			#var x = iris["centroid"][0]
			#var y = iris["centroid"][1]
			#
			#var gx = 0.0
			#var gy = 0.0
			#if data.has("global_mov"):
				#gx = data["global_mov"][0]
				#gy = data["global_mov"][1]
			#
			##var rel_x = x - gx
			##var rel_y = y - gy
#
			##var norm_x = rel_x / video_width
			##var norm_y = rel_y / video_height
			#var eye_center_x = video_width / 2 + gx
			#var eye_center_y = video_height / 2 + gy
#
			#var rel_x = x - eye_center_x
			#var rel_y = y - eye_center_y
#
			#var norm_x = rel_x / video_width
			#var norm_y = rel_y / video_height
#
			##var norm_x = (rel_x - video_width / 2.0) / video_width
			##var norm_y = (rel_y - video_height / 2.0) / video_height
#
			#rotation.y = norm_x * rotation_scale_y + eye_rotation_offset.y #the other way around, since x is left and right in the video but with rotation the y axis handles left right 
			#rotation.x = norm_y * rotation_scale_y + eye_rotation_offset.x

			
		# Iris full mesh scaling (size of eye)			
		if iris.has("length"):
			var length = iris["length"]
			var iris_height = length[0]  # vertical (Y) %switch
			var iris_width = length[1]   # horizontal (X)

			# Normalize separately for width and height
			var t_x = clamp((iris_width - min_iris_width) / (max_iris_width - min_iris_width), 0.0, 1.0)
			var t_y = clamp((iris_height - min_iris_height) / (max_iris_height - min_iris_height), 0.0, 1.0)

			var scale_x = lerp(iris_scale_range.x, iris_scale_range.y, t_x)
			var scale_y = lerp(iris_scale_range.x, iris_scale_range.y, t_y)

			var base_scale = 0.82  # Tune this until the iris fits well/0.82 %switch
			iris_node.scale = Vector3(scale_x, scale_y, scale_y) * base_scale #z is x because depth is very small and otherwise it would be off, can also be y, just used as default
		
		#angle change with iris angle, should later add based on if one is missing, use pupil angle
		if iris.has("angle"):
			var angle = iris["angle"]
			var corrected_angle = -deg_to_rad(angle - 90.0)  # Subtract 90° to switch to major ellipse diameter, then negate to move clockwise
			iris_node.rotation.z = corrected_angle
	
	# Pupil dilation inside iris mesh
	if data.has("2"):
		var pupil = data["2"]
		if pupil.has("length"):
			var length = pupil["length"]
			iris_node.call("set_pupil_scale_elliptical",
				length[0], length[1],  # pupil width and height from current frame %switch
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
