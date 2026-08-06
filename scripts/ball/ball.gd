extends RigidBody3D

enum BallState {
	FREE,
	CONTROLLED
}

var state := BallState.FREE
var ball_owner: CharacterBody3D = null
var control_cooldown := 0.0

const CONTROL_DISTANCE := 1.2
const FOLLOW_SPEED := 8.0

func _physics_process(delta):
	if control_cooldown > 0.0:
		control_cooldown -= delta

	# Enquanto estiver no cooldown, não deixa a bola ser controlada
	if control_cooldown > 0.0:
		return

	if state == BallState.CONTROLLED and ball_owner != null:

		var target = ball_owner.get_node("BallControlPoint").global_position

		var distance = global_position.distance_to(target)

		if distance > 0.05:
			global_position = global_position.move_toward(target, FOLLOW_SPEED * delta)

		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
