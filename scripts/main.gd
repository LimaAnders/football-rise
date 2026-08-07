extends Node3D

@onready var ball = $Ball
@onready var player = $Player
@onready var player2 = $Player2
@onready var ball_spawn = $BallSpawn
@onready var player_spawn = $PlayerSpawn
@onready var player2_spawn = $Player2Spawn
@onready var score_label = $UI/ScoreLabel

var score_top := 0
var score_bottom := 0

@onready var timer_label = $UI/TimerLabel

var match_time := 90

@onready var camera_rig = $CameraRig

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()
	update_timer()

func _process(delta):
	pass
	
func _on_goal_top_body_entered(body):
	if body.name == "Ball":
		score_bottom += 1
		update_score()

		print("GOOOOL! Time de baixo marcou!")

		$MatchTimer.stop()
		$GoalTimer.start()

func _on_goal_bottom_body_entered(body):
	if body.name == "Ball":
		score_top += 1
		update_score()

		print("GOOOOL! Time de cima marcou!")

		$MatchTimer.stop()
		$GoalTimer.start()
	
func reset_match():
	ball.state = ball.BallState.FREE
	ball.ball_owner = null
	ball.control_cooldown = 0.5

	ball.linear_velocity = Vector3.ZERO
	ball.angular_velocity = Vector3.ZERO
	ball.global_position = ball_spawn.global_position

	player.velocity = Vector3.ZERO
	player.global_position = player_spawn.global_position

	player2.velocity = Vector3.ZERO
	player2.global_position = player2_spawn.global_position

func update_score():
	score_label.text = str(score_top) + " x " + str(score_bottom)

func update_timer():
	var minutes := int(match_time / 60)
	var seconds := int(match_time % 60)

	timer_label.text = "%02d:%02d" % [minutes, seconds]


func _on_match_timer_timeout() -> void:
	if match_time > 0:
		match_time -= 1
		update_timer()
	else:
		$MatchTimer.stop()
		print("Fim da partida!")


func _on_goal_timer_timeout() -> void:
	reset_match()
	$MatchTimer.start()
