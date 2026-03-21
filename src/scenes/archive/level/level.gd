extends Node2D

const TOUT = preload("uid://wwl0b2jylh3b")
const SIZE : Vector2i = Vector2i(16, 9)


func _ready() -> void:
	init()


func init() -> void:
	generate_touts()


func generate_touts() -> void:
	for x in range(SIZE.x):
		for y in range(SIZE.y):
			
			var new_tout : Tout = TOUT.instantiate()
			new_tout.position = (Vector2(0.5, 0.5) + Vector2(x, y)) * Tout.WIDTH
