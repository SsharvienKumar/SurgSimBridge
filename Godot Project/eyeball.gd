extends Node3D




#func _ready():
	##flinch_eye()
	

func flinch_eye(offset := Vector3(0, -1, 0), return_delay := 0.1):
	print("flinch triggered")
	var original_rotation = rotation_degrees  # Save the current rotation
	rotation_degrees += offset              # Apply a quick jolt
	await get_tree().create_timer(return_delay).timeout  # Wait a short time
	rotation_degrees = original_rotation      # Snap back to normal
	

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
