extends CharacterBody2D

const SPEED = 400.0
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

func _ready():
	visible_on_screen_notifier_2d.screen_exited.connect(self.queue_free)

func _physics_process(delta):
	var collision = move_and_collide(Vector2.UP * SPEED * delta)
	if(collision):
		collision.get_collider().was_shot()
		queue_free()
