@tool
class_name NatureOption extends Area2D

signal click(option: NatureOption, is_selected: bool)

@export var base_head: Node2D

@onready var tout_animation: AnimatedSprite2D = %ToutAnimation
var is_selected : bool = false

@export var nature: Tout.Mode = Tout.Mode.MOVING:
	set(new_nature):
		nature = new_nature
		_draw_nature(nature)


func _ready() -> void:
	_draw_nature(nature)
	mouse_entered.connect(func(): 
		if not is_selected:
			scale = Vector2(2.4, 2.4)
	)
	mouse_exited.connect(func(): 
		if not is_selected:
			unselect()
	)

func setup() -> void:
	base_head.position = position + Vector2(0, 35)

var frame_taken = false
func _input_event(_viewport: Viewport, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click") and not frame_taken:
		frame_taken = true
		is_selected = not is_selected
		click.emit(self, is_selected)
		if is_selected:
			select()
		else:
			unselect()
		await get_tree().process_frame
		frame_taken = false

func select() -> void:
	scale = Vector2(2.6, 2.6)
	modulate = Color(0.276, 0.782, 0.9, 1.0)

func unselect() -> void:
	is_selected = false
	scale = Vector2(2.09, 2.09)
	modulate = Color.WHITE


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
