extends Node3D




#func _ready():
	#flinch_eye()
	#$Iris.scale.x = 150

@export var json_folder := "res://case_2000_nn_data"
@export var video_width := 533
@export var video_height := 300
@export var rotation_scale := 0.8  # How sensitive the eye is

var frames := []           # List of JSON file names (sorted by frame)
var current_frame := 0     # Keeps track of current frame

var frame_time := 1.0 / 15.0  # One frame every 1/15 seconds
var time_accumulator := 0.0

func _ready():
	load_all_jsons()

func load_all_jsons():
	var dir = DirAccess.open(json_folder)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".json"):
				frames.append(file)
			file = dir.get_next()
		dir.list_dir_end()
		frames.sort_custom(func(a, b): return a < b)
	else:
		print("Failed to open JSON folder.")
		
#func _process(delta):
	#time_accumulator += delta
	#if time_accumulator < frame_time:
		#return
	#time_accumulator = 0.0  # Reset after advancing one frame
	#
	#if current_frame >= frames.size():
		#print("All frames processed.")
		#set_process(false)  # Stop _process() from running
		#return
#
	#var file = frames[current_frame]
	#var path = json_folder + "/" + file
	#var json = FileAccess.get_file_as_string(path)
	#var data = JSON.parse_string(json)
	#
	#if typeof(data) == TYPE_DICTIONARY and data.has("1"):  # We use the entry with key "1"
		#var point = data["1"]
		#if point.has("centroid"):
			#var x = point["centroid"][0]
			#var y = point["centroid"][1]
#
			## Normalize pixel position to center of video frame
			#var norm_x = (x - video_width / 2.0) / video_width
			#var norm_y = (y - video_height / 2.0) / video_height
#
			## Rotate the eye: horizontal = Y, vertical = X
			#rotation.y = norm_x * rotation_scale
			#rotation.x = -norm_y * rotation_scale
	#current_frame += 1


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
