extends Node2D

@onready var nature_options_container = $Natures
var selected
var nature_to_function : Dictionary = {
	Tout.Mode.MOVING : Tout.Mode.MOVING,
	Tout.Mode.BLOCKING : Tout.Mode.BLOCKING,
	Tout.Mode.KILLING : Tout.Mode.KILLING,
	Tout.Mode.ENDING : Tout.Mode.ENDING,
	Tout.Mode.DECORING : Tout.Mode.DECORING,
	Tout.Mode.COLLECTING : Tout.Mode.COLLECTING,
}

var is_switching = false

func _ready() -> void:
	for nature_option: NatureOption in nature_options_container.get_children():
		nature_option.click.connect(_on_click)
		print(nature_option)


func _on_click(option: NatureOption) -> void:
	if is_switching:
		return
	if selected == option:
		return
	if selected == null:
		selected = option
		return
	assert(selected is NatureOption)
	switch(selected, option)
	selected.unselect()
	option.unselect()
	selected = null


func switch(option_a: NatureOption, option_b: NatureOption) -> void:
	is_switching = true
	var position_a = option_a.position
	var position_b = option_b.position
	var duration = 0.2
	var tween_a = create_tween()
	tween_a.tween_property(option_a, "position", position_b, duration)
	var tween_b = create_tween()
	tween_b.tween_property(option_b, "position", position_a, duration)
	await tween_a.finished
	await tween_b.finished
	is_switching = false
