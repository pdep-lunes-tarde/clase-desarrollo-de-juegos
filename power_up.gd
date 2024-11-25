extends Area2D

func _ready():
	body_entered.connect(self.apply_powerup)
	
func apply_powerup(player):
	set_deferred("monitoring", false)
	player.upgrade_fire_rate()
	create_tween().tween_property(
		self,
		"scale",
		Vector2.ZERO,
		0.5
	).set_trans(Tween.TRANS_ELASTIC)
	await create_tween().tween_property(
		self,
		"rotation",
		PI * 7.0,
		0.5
	).set_trans(Tween.TRANS_ELASTIC).finished
	self.queue_free
