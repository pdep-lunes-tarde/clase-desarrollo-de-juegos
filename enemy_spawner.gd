extends Node2D

const ENEMY_ALAN = preload("res://enemy_alan.tscn")
@onready var timer = $Timer
@onready var end_position = $EndPosition
@onready var initial_position = $InitialPosition

var difficulty: float = 1

signal enemy_died

func _ready():
	timer.timeout.connect(self.spawn_enemy)

func spawn_enemy():
	var new_enemy = ENEMY_ALAN.instantiate()
	var enemy_position = Vector2(
		randf_range(
			initial_position.global_position.x,
			end_position.global_position.x,
		),
		global_position.y
	)
	add_child(new_enemy)
	new_enemy.global_position = enemy_position
	new_enemy.died.connect(self.on_enemy_died)
	new_enemy.global_scale =\
		new_enemy.global_scale * min(1.5, 1 + difficulty / 10.0)

func on_enemy_died():
	enemy_died.emit()
	timer.wait_time = move_toward(
		timer.wait_time,
		0.5,
		0.05
	)
	difficulty+= 1
