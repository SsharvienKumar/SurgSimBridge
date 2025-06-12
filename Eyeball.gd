extends Node3D

@export var max_angle_deg := 30.0  # Maximum rotation angle (degrees)
@export var smoothness := 3.0      # Smoothing coefficient, the larger the smoothing coefficient, the slower the smoothing coefficient.

var target_rot := Vector3.ZERO

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport().get_visible_rect().size
	var norm_x = ((mouse_pos.x / screen_size.x) - 0.5) * 2
	var norm_y = ((mouse_pos.y / screen_size.y) - 0.5) * 2

	# Angle Limit
	var max_rad = deg_to_rad(max_angle_deg)
	target_rot.x = clamp(-norm_y * max_rad, -max_rad, max_rad)
	target_rot.y = clamp(norm_x * max_rad, -max_rad, max_rad)

	# Smooth movement: Linear interpolation
	rotation.x = lerp(rotation.x, target_rot.x, delta * smoothness)
	rotation.y = lerp(rotation.y, target_rot.y, delta * smoothness)
