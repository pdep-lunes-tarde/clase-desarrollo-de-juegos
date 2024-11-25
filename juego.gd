extends Node2D

@onready var enemy_spawner = $EnemySpawner
@onready var score = $Score
@onready var health_bar = $HealthBar
@onready var player = $Player

var enemies_killed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_spawner.enemy_died.connect(func():
		enemies_killed += 1
	)
	health_bar.max_value = player.max_health

func _physics_process(delta):
	score.text = "Score: %s" % enemies_killed
	health_bar.value = player.health
