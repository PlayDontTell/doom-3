extends Node2D


var has_mode_attached : bool = true
@export var nature : Tout.Mode


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if InputManager.pressed("left_click") and has_mode_attached:
		has_mode_attached = not has_mode_attached
