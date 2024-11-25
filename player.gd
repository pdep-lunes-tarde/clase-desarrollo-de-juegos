extends CharacterBody2D

var base_speed = 300.0
var dash_speed = base_speed * 5.0
var dashing_time_left: float = 0.0
var max_dashing_time: float = 0.02
const BEAM = preload("res://beam.tscn")
@onready var shaker = $Shaker
@export var max_health = 100
var health = max_health
@export var time_between_shoots: float = 0.2
var time_left_until_next_shoot: float = 0.0
@export var invulnerability_time: float = 0.5
var invulnerability_time_left: float = 0.0
@onready var dashing_particles = $DashingParticles


func is_dashing():
	return dashing_time_left > 0.0

func speed():
	return dash_speed if is_dashing() else base_speed

func upgrade_fire_rate():
	time_between_shoots = move_toward(
		time_between_shoots,
		0.01,
		0.05
	)

func _physics_process(delta):
	if(is_invulnerable()):
		visible = Engine.get_frames_drawn() % 2 == 0
	else:
		visible = true
	var direccion: Vector2 = Input.get_vector(
		"ui_left","ui_right","ui_up","ui_down"
	)
	if not direccion.is_zero_approx():
		move_and_collide(direccion * speed() * delta)
	if Input.is_action_pressed("shoot") and can_shoot():
		shoot()
	if Input.is_action_pressed("dash"):
		dash()
	dashing_particles.emitting = is_dashing()
	time_left_until_next_shoot -= delta
	invulnerability_time_left -= delta
	dashing_time_left -= delta

func dash():
	dashing_time_left = max_dashing_time

func can_shoot() -> bool:
	return time_left_until_next_shoot <= 0.0 

func is_invulnerable() -> bool:
	return invulnerability_time_left > 0.0

func hit_by_enemy():
	if(is_invulnerable()):
		return

	health -= 5
	shaker.start()
	invulnerability_time_left = invulnerability_time
	if(health <= 0):
		queue_free()
		get_tree().reload_current_scene()

func shoot() -> void:
	var beam = BEAM.instantiate()
	get_parent().add_child(beam)
	beam.global_position = global_position
	time_left_until_next_shoot = time_between_shoots
