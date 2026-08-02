extends CharacterBody3D

const SPEED := 6.0
const KICK_FORCE := 20.0
@onready var ball = $"../Ball"

func _physics_process(delta):
	var direction := Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if Input.is_action_pressed("move_back"):
		direction.z += 1

	if Input.is_action_pressed("move_left"):
		direction.x -= 1

	if Input.is_action_pressed("move_right"):
		direction.x += 1

	direction = direction.normalized()

	if direction != Vector3.ZERO:
		rotation.y = atan2(direction.x, direction.z)

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
	
	if Input.is_action_just_pressed("kick"):
		var distance = global_position.distance_to(ball.global_position)

		if distance < 2.0:
			var dir = (ball.global_position - global_position).normalized()
			ball.apply_central_impulse(dir * KICK_FORCE)
