extends CharacterBody2D

const EXPLOSION = preload("res://explosion.tscn")
const POWER_UP = preload("res://power_up.tscn")
const ENEMY_PROJECTILE = preload("res://enemy_projectile.tscn")

@export var vertical_speed: float = 100.0
var max_health: float = 10
var health: float = max_health
@onready var shaker = $Shaker
@onready var shoot_timer = $ShootTimer

signal died

func _ready():
	shoot_timer.wait_time = randf_range(1.5, 3.5)
	shoot_timer.timeout.connect(self.shoot)

func shoot():
	for direction in [Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)]:
		var projectile = spawn(ENEMY_PROJECTILE)
		projectile.direction = direction

func _physics_process(delta):
	var collision = move_and_collide(Vector2.DOWN * vertical_speed * delta)
	if collision:
		collision.get_collider().hit_by_enemy()
		explode()

func was_shot():
	health -= 1
	shaker.start()
	modulate = Color.WHITE.lerp(Color.RED, (max_health - health) / max_health)
	if(health <= 0):
		explode()

func explode():
	died.emit()
	spawn(EXPLOSION)
	if(randf() < 0.2):
		spawn(POWER_UP)
	queue_free()
	
func spawn(scene: PackedScene):
	var instance = scene.instantiate()
	get_parent().add_child(instance)
	instance.global_position = global_position
	return instance
