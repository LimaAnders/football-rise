extends CharacterBody3D

const SPEED := 6.0
const KICK_FORCE := 20.0
@onready var ball = $"../Ball"

@export var move_forward_action := "move_forward"
@export var move_back_action := "move_back"
@export var move_left_action := "move_left"
@export var move_right_action := "move_right"
@export var kick_action := "kick"

func _physics_process(delta):
	var direction := Vector3.ZERO

	if Input.is_action_pressed(move_forward_action):
		direction.z -= 1

	if Input.is_action_pressed(move_back_action):
		direction.z += 1

	if Input.is_action_pressed(move_left_action):
		direction.x -= 1

	if Input.is_action_pressed(move_right_action):
		direction.x += 1

	direction = direction.normalized()

	if direction != Vector3.ZERO:
		rotation.y = atan2(direction.x, direction.z)

	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
	
	if Input.is_action_just_pressed(kick_action):
		var distance = global_position.distance_to(ball.global_position)

		if distance < 2.0:
			var dir = (ball.global_position - global_position).normalized()
			ball.apply_central_impulse(dir * KICK_FORCE)
