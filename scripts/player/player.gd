extends CharacterBody3D

const SPEED := 6.0
const KICK_FORCE := 20.0
const BALL_CONTROL_DISTANCE := 2.0

const MAX_KICK_CHARGE := 1.0
const MAX_PASS_CHARGE := 1.0

const MIN_KICK_FORCE := 10.0
const MAX_KICK_FORCE := 20.0
const MIN_PASS_FORCE := 5.0
const MAX_PASS_FORCE := 12.0

const MIN_CROSS_FORCE := 8.0
const MAX_CROSS_FORCE := 22.0
const MIN_CROSS_VERTICAL := 4.0
const MAX_CROSS_VERTICAL := 10.0
const MAX_CROSS_CHARGE := 1.0

@onready var ball = $"../Ball"

var pass_charge := 0.0
var kick_charge := 0.0
var cross_charge := 0.0

@export var move_forward_action := "move_forward"
@export var move_back_action := "move_back"
@export var move_left_action := "move_left"
@export var move_right_action := "move_right"

@export var pass_action := "pass"
@export var shoot_action := "shoot"
@export var cross_action := "cross"
@export var sprint_action := "sprint"


func _physics_process(delta):
	var direction := Vector3.ZERO

	# Movimento
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

	# =========================
	# CHUTE - K
	# =========================

	if Input.is_action_pressed(shoot_action):
		if ball.ball_owner == self:
			kick_charge += delta

	if Input.is_action_just_released(shoot_action):
		if ball.ball_owner == self:

			var charge = min(kick_charge, MAX_KICK_CHARGE)
			kick_charge = 0.0

			ball.state = ball.BallState.FREE
			ball.ball_owner = null
			ball.control_cooldown = 0.4

			var dir = (ball.global_position - global_position).normalized()

			var force = lerp(
				MIN_KICK_FORCE,
				MAX_KICK_FORCE,
				clamp(charge / MAX_KICK_CHARGE, 0.0, 1.0)
			)

			ball.apply_central_impulse(dir * force)

	# =========================
	# PASSE - J
	# =========================

	# Carregar passe
	if Input.is_action_pressed(pass_action):
		if ball.ball_owner == self:
			pass_charge += delta


	# Soltar passe
	if Input.is_action_just_released(pass_action):
		if ball.ball_owner == self:

			var charge = min(pass_charge, MAX_PASS_CHARGE)
			pass_charge = 0.0

			ball.state = ball.BallState.FREE
			ball.ball_owner = null
			ball.control_cooldown = 0.4

			var dir = (ball.global_position - global_position).normalized()

			var force = lerp(
				MIN_PASS_FORCE,
				MAX_PASS_FORCE,
				clamp(charge / MAX_PASS_CHARGE, 0.0, 1.0)
			)

			ball.apply_central_impulse(dir * force)
			
			
	# =========================
	# CRUZAMENTO - L
	# =========================
		
	# Carregar cruzamento
	if Input.is_action_pressed(cross_action):
		if ball.ball_owner == self:
			cross_charge += delta
			
	# Soltar cruzamento
	if Input.is_action_just_released(cross_action):
		if ball.ball_owner == self:

			var charge = min(cross_charge, MAX_CROSS_CHARGE)
			cross_charge = 0.0

			ball.state = ball.BallState.FREE
			ball.ball_owner = null
			ball.control_cooldown = 0.4

			var cross_dir = transform.basis.z.normalized()

			var force = lerp(
				MIN_CROSS_FORCE,
				MAX_CROSS_FORCE,
				clamp(charge / MAX_CROSS_CHARGE, 0.0, 1.0)
			)

			var cross_direction = cross_dir * force

			var vertical_force = lerp(
				MIN_CROSS_VERTICAL,
				MAX_CROSS_VERTICAL,
				clamp(charge / MAX_CROSS_CHARGE, 0.0, 1.0)
			)

			cross_direction.y = vertical_force

			ball.apply_central_impulse(cross_direction)

	# =========================
	# CONTROLE DA BOLA
	# =========================

	if ball.control_cooldown <= 0.0:
		if global_position.distance_to(ball.global_position) <= BALL_CONTROL_DISTANCE:
			ball.ball_owner = self
			ball.state = ball.BallState.CONTROLLED
