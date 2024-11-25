extends ParallaxBackground

const SCROLL_SPEED = 100.0

func _physics_process(delta):
	scroll_offset += Vector2.DOWN * delta * SCROLL_SPEED
