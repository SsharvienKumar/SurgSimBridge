extends Node3D

var radius = 2.8
var t = 0.0
var dilating = false

func _process(delta: float) -> void:
	if dilating:
		t += delta
		radius = 0.5 * (0.5 * sin(t) + 1)
		$Iris.inner_radius = radius

func _input(event):
	if event.is_action_pressed("ui_accept"):  # default is spacebar or Enter
		dilating = !dilating
