extends AnimatedSprite2D

func _ready():
	animation_finished.connect(self.queue_free)
