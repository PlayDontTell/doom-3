@tool
class_name NatureOption extends Area2D

signal click(option: NatureOption)

@export var base_head: Node2D

@onready var tout_animation: AnimatedSprite2D = %ToutAnimation
var is_selected : bool = true

@export var nature: Tout.Mode = Tout.Mode.MOVING:
	set(new_nature):
		nature = new_nature
		_draw_nature(nature)


func _ready() -> void:
	_draw_nature(nature)


func _input_event(_viewport: Viewport, _event: InputEvent, _shape_idx: int) -> void:
	if InputManager.just_pressed("left_click"):
		click.emit(self)


func unselect() -> void:
	is_selected = false


func _draw_nature(new_nature : Tout.Mode) -> void:
	if tout_animation == null:
		return
	match new_nature:
		Tout.Mode.MOVING: tout_animation.animation = "moving"
		Tout.Mode.BLOCKING: tout_animation.animation = "blocking"
		Tout.Mode.KILLING: tout_animation.animation = "killing"
		Tout.Mode.ENDING: tout_animation.animation = "ending"
		Tout.Mode.DECORING: tout_animation.animation = "decoring"
		Tout.Mode.COLLECTING: tout_animation.animation = "collecting"
