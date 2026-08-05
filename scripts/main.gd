extends Node3D

@onready var ball = $Ball
@onready var player = $Player
@onready var ball_spawn = $BallSpawn
@onready var player_spawn = $PlayerSpawn
@onready var score_label = $UI/ScoreLabel

var score_top := 0
var score_bottom := 0

@onready var timer_label = $UI/TimerLabel

var match_time := 90

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()
	update_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_goal_top_body_entered(body):
	if body.name == "Ball":
		score_bottom += 1
		update_score()
		print("GOOOOL! Time de baixo marcou!")
		reset_match()

func _on_goal_bottom_body_entered(body):
	if body.name == "Ball":
		score_top += 1
		update_score()
		print("GOOOOL! Time de cima marcou!")
		reset_match()
	
func reset_match():
	# Reposiciona a bola
	ball.linear_velocity = Vector3.ZERO
	ball.angular_velocity = Vector3.ZERO
	ball.global_position = ball_spawn.global_position

	# Reposiciona o jogador
	player.velocity = Vector3.ZERO
	player.global_position = player_spawn.global_position

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
		print("Fim da partida!")# Replace with function body.
