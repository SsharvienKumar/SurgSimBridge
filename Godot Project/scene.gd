extends Node3D

@export var json_folder := "res://synthetic_json"
@export var video_width := 533
@export var video_height := 300

@onready var eyeball_node := $Eyeball
@onready var camera_node := $Camera3D
@onready var incknife_node := $"incision knife tip"

var frames := []           # List of JSON file names (sorted by frame)
var current_frame := 0     # Keeps track of current frame
var frame_time := 1.0 / 15.0  # One frame every 1/15 seconds
var time_accumulator := 0.0


func _ready():
	load_all_jsons()
	#var ranges = calculate_range_values()
	#eyeball_node.set_ranges(ranges)

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


func calculate_range_values():
	var iris_widths = []
	var iris_heights = []
	var pupil_widths = []
	var pupil_heights = []

	for file in frames:
		var path = json_folder + "/" + file
		var json = FileAccess.get_file_as_string(path)
		var data = JSON.parse_string(json)

		if typeof(data) == TYPE_DICTIONARY:
			if data.has("1") and data["1"].has("length"):
				var iris_len = data["1"]["length"]
				iris_heights.append(iris_len[0])
				iris_widths.append(iris_len[1])

			if data.has("2") and data["2"].has("length"):
				var pupil_len = data["2"]["length"]
				pupil_heights.append(pupil_len[0])
				pupil_widths.append(pupil_len[1])

	# Find min and max values
	var min_iris_width = iris_widths.min()
	var max_iris_width = iris_widths.max()
	var min_iris_height = iris_heights.min()
	var max_iris_height = iris_heights.max()

	var min_pupil_width = pupil_widths.min()
	var max_pupil_width = pupil_widths.max()
	var min_pupil_height = pupil_heights.min()
	var max_pupil_height = pupil_heights.max()

	return {
		"iris": {
			"min_width": min_iris_width, "max_width": max_iris_width,
			"min_height": min_iris_height, "max_height": max_iris_height,
		},
		"pupil": {
			"min_width": min_pupil_width, "max_width": max_pupil_width,
			"min_height": min_pupil_height, "max_height": max_pupil_height,
		}
	}

func _process(delta):
	time_accumulator += delta
	if time_accumulator < frame_time:
		return
	time_accumulator = 0.0  # Reset after advancing one frame
	
	if current_frame >= frames.size():
		print("All frames processed.")
		set_process(false)  # Stop _process() from running
		return

	var file = frames[current_frame]
	var path = json_folder + "/" + file
	var json = FileAccess.get_file_as_string(path)
	var data = JSON.parse_string(json)

	if typeof(data) == TYPE_DICTIONARY:
		eyeball_node.process_data(data, video_width, video_height) #eyemovements/size/dilation
		#if data.has("global_mov"):
			#camera_node.update_camera(data["global_mov"], video_width, video_height) #global/cameramovements
		if data.has("4"):
			incknife_node.update_incknife(data["4"], video_width, video_height)
		else:
			incknife_node.update_incknife({}, video_width, video_height)

	#var output_folder = "user://rendered_frames"
	#DirAccess.make_dir_absolute(output_folder)  # Create the folder (if not already)
	#if current_frame < frames.size():
		#var img: Image = get_viewport().get_texture().get_image()
		#var filename = "%s/%010d.png" % [output_folder, current_frame]
		#img.save_png(filename)

		current_frame += 1


#@onready var anim_player = $AnimationPlayer
#
#func _ready():
	#print(anim_player)  # Should not be null
	#anim_player.animation_finished.connect(_on_animation_finished)
	##await get_tree().create_timer(0.2).timeout
	#anim_player.play("Incision")
#
#func play_incision_anim():
	#anim_player.play("Incision")
#
#func _on_animation_finished(anim_name):
	#if anim_name == "Incision":
		#await get_tree().create_timer(0.2).timeout
		#get_tree().quit()
		
