extends Node3D

@export var target: Node3D
@export var smooth_speed := 5.0

func _process(delta):
	if target == null:
		return

	global_position = global_position.lerp(
		target.global_position,
		smooth_speed * delta
	)
