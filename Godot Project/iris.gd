extends MeshInstance3D

@export var radius_threshold := 2.0
@export var pupil_z := 0.5
@export var z_tolerance := 0.6

var original_vertices = []  # Store original vertex positions
var base_mesh: Mesh

func _ready():
	base_mesh = mesh
	if base_mesh == null or base_mesh.get_surface_count() == 0:
		print("No valid mesh found.")
		return

	var mdt := MeshDataTool.new()
	if mdt.create_from_surface(base_mesh, 0) != OK:
		print("Failed to load mesh into MeshDataTool.")
		return

	# Save original vertex positions
	for i in mdt.get_vertex_count():
		original_vertices.append(mdt.get_vertex(i))


func set_pupil_scale_elliptical(
	width: float, height: float,
	min_pupil_width: float, max_pupil_width: float, min_pupil_height: float, max_pupil_height: float,
	scale_range: Vector2 #scale should be max 2.2 otherwise goes over other vertices and black rim appears (change in blender?)
	):

	if original_vertices.size() == 0:
		print("Original vertices not stored.")
		return
		
	#use only radius since the scaling is in radii
	var radius_width = width / 2.0
	var radius_height = height / 2.0
	
	var radius_max_pupil_width = max_pupil_width / 2.0
	var radius_min_pupil_width = min_pupil_width / 2.0
	var radius_max_pupil_height = max_pupil_height / 2.0
	var radius_min_pupil_height = min_pupil_height / 2.0

	var pupil_width_scale = clamp((radius_width - radius_min_pupil_width) / (radius_max_pupil_width - radius_min_pupil_width), 0.0, 1.0)
	var pupil_height_scale = clamp((radius_height - radius_min_pupil_height) / (radius_max_pupil_height - radius_min_pupil_height), 0.0, 1.0)

	var scale_x = lerp(scale_range.x, scale_range.y, pupil_width_scale)
	var scale_y = lerp(scale_range.x, scale_range.y, pupil_height_scale)


	var mdt = MeshDataTool.new()
	if mdt.create_from_surface(base_mesh, 0) != OK:
		print("Failed to reload mesh.")
		return

	for i in mdt.get_vertex_count():
		var v = original_vertices[i]
		if abs(v.z - pupil_z) < z_tolerance:
			var xy = Vector2(v.x, v.y)
			if xy.length() < radius_threshold:
				var scaled_v = Vector3(v.x * scale_x, v.y * scale_y, v.z)
				mdt.set_vertex(i, scaled_v)
			else:
				mdt.set_vertex(i, v)
		else:
			mdt.set_vertex(i, v)

	var new_mesh = ArrayMesh.new()
	mdt.commit_to_surface(new_mesh)
	mesh = new_mesh


##test pupil dilation
#@export var iris_scale := 1
#@export var radius_threshold := 2
#@export var pupil_z := 0.5
#@export var z_tolerance := 0.6  # NEW: Capture both front & back rings
#
#func _ready():
	#var original_mesh := self.mesh
	#if original_mesh == null or original_mesh.get_surface_count() == 0:
		#print("No valid mesh found.")
		#return
#
	#var mdt := MeshDataTool.new()
	#if mdt.create_from_surface(original_mesh, 0) != OK:
		#print("Failed to load mesh into MeshDataTool.")
		#return
#
	#var modified := 0
	#for i in mdt.get_vertex_count():
		#var v := mdt.get_vertex(i)
		#if abs(v.z - pupil_z) < z_tolerance:
			#var xy := Vector2(v.x, v.y)
			#if xy.length() < radius_threshold:
				#var new_v := Vector3(v.x * iris_scale, v.y * iris_scale, v.z)
				#mdt.set_vertex(i, new_v)
				#modified += 1
#
	#print("Modified vertices:", modified)
#
	#var new_mesh := ArrayMesh.new()
	#mdt.commit_to_surface(new_mesh)
	#self.mesh = new_mesh
