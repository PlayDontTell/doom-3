
extends Node
func _ready() -> void:
	play()
	
func play():
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	play()
