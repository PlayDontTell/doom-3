@tool
extends Node2D

@onready var tout_animation: AnimatedSprite2D = %ToutAnimation

@export var nature : Tout.Mode = Tout.Mode.MOVING:
	set(new_nature):
		nature = new_nature
		draw_nature(nature)


func _ready() -> void:
	draw_nature(nature)


func draw_nature(new_nature : Tout.Mode) -> void:
	match new_nature:
		Tout.Mode.MOVING: tout_animation.animation = "moving"
		Tout.Mode.BLOCKING: tout_animation.animation = "blocking"
		Tout.Mode.KILLING: tout_animation.animation = "killing"
		Tout.Mode.ENDING: tout_animation.animation = "ending"
		Tout.Mode.DECORING: tout_animation.animation = "decoring"
		Tout.Mode.COLLECTING: tout_animation.animation = "collecting"
