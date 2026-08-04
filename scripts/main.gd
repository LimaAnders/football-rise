extends Node3D

@onready var ball = $Ball
@onready var player = $Player

@onready var ball_spawn = $BallSpawn
@onready var player_spawn = $PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_goal_top_body_entered(body):
	if body.name == "Ball":
		print("GOOOOL! Time de baixo marcou!")
		reset_match()

func _on_goal_bottom_body_entered(body):
	if body.name == "Ball":
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
