extends AnimatedSprite2D

func _ready() -> void:
	_lauch_anim()

## random timing to auto-start anim
func _lauch_anim():
	await get_tree().create_timer(randf() * 10.).timeout
	self.play()
