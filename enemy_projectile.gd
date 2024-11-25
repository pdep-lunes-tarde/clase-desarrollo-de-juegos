extends CharacterBody2D

const SPEED = 100.0
@export var direction: Vector2

func _physics_process(delta):
	var collision = move_and_collide(direction * delta * SPEED)
	if collision:
		collision.get_collider().hit_by_enemy()
		queue_free()
