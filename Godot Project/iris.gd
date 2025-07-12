extends MeshInstance3D

var base_mesh : ArrayMesh
var original_vertices : PackedVector3Array

@export var inner_radius_threshold := 1.5  # your measured inner radius
@export var scale_factor := 0.6  # shrink factor for the inner hole

func _ready():
	shrink_inner_radius()

func shrink_inner_radius():
	var m := mesh
	if m is ArrayMesh:
		var arrays := m.surface_get_arrays(0)
		var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		var new_verts: PackedVector3Array = verts.duplicate()

		var pupil_center = Vector3(0, 0, 11.3)
		var count := 0

		for i in range(new_verts.size()):
			var v = new_verts[i]

			var dist = Vector2(v.x - pupil_center.x, v.z - pupil_center.z).length()
			if dist < inner_radius_threshold:
				var local_pos = Vector3(v.x - pupil_center.x, v.y - pupil_center.y, v.z - pupil_center.z)
				local_pos *= scale_factor
				new_verts[i] = pupil_center + local_pos
				count += 1

		print("Total vertices modified: ", count)
		arrays[Mesh.ARRAY_VERTEX] = new_verts
		m.clear_surfaces()
		m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)






#func _ready():
	#print("Vertices test running.")
	#var mesh_data = mesh.surface_get_arrays(0)
	#var verts = mesh_data[Mesh.ARRAY_VERTEX]
	#for v in verts:
		#print(v)

# Called once at the beginning
#func _ready():
	#var arrays = mesh.surface_get_arrays(0)
	#original_vertices = arrays[Mesh.ARRAY_VERTEX].duplicate()
	#
	#var new_mesh := ArrayMesh.new()
	#new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#mesh = new_mesh
	##set_inner_radius_debug()
	#set_inner_radius(0.6)  # Try different values
#
#
#func set_inner_radius(new_radius: float):
	##print("is this working?")
	#var arrays = mesh.surface_get_arrays(0)
	#var vertices : PackedVector3Array = original_vertices.duplicate()
	#
	#var center = Vector3(0, 0, 11.3)  # Your known pupil center
	#var threshold = 11
	#
	#for i in range(vertices.size()):
		##print("still working?")
		#var vertex = vertices[i]
		#var pos = vertex - center  # Shift so center is at (0,0,0)
		#var dist = sqrt(pos.x * pos.x + pos.z * pos.z)
		##print(dist)
		 ## If vertex is near the center (the pupil), scale its distance
		#if dist < threshold:  # 0.2 = inner threshold; tweak if needed
			#print("near center?")
			#var direction = Vector3(pos.x, 0, pos.z).normalized()
			#var new_pos = direction * new_radius
			#new_pos.y = pos.y  # Keep height unchanged
			#vertices[i] = center + new_pos  # Shift back
#
	## Update mesh with new vertices
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	#print("do we even get here?")
	#var new_mesh := ArrayMesh.new()
	#new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	#mesh = new_mesh
#
#func set_inner_radius_debug():
	#var arrays = mesh.surface_get_arrays(0)
	#var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	#var center = Vector3(0, 0, 11.3)
#
	#var min_dist = 9999
	#var max_dist = -9999
#
	#for vertex in vertices:
		#var pos = vertex - center
		#var dist = sqrt(pos.x * pos.x + pos.z * pos.z)
		#min_dist = min(min_dist, dist)
		#max_dist = max(max_dist, dist)
#
		#print("Distance range from center to vertices: ", min_dist, " - ", max_dist)
