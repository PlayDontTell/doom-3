class_name Game extends Node2D

var level: Level
var current_level_number: int = 1

const LAST_LEVEL = 4
const config_bar_pack = preload("res://src/scenes/ui/config_bar/config_bar.tscn")
var config_bar: ConfigBar

func _ready() -> void:
	_load_level(current_level_number)


func _load_config_bar():
	if config_bar != null:
		config_bar.changed.disconnect(_on_change_modes)
		config_bar.queue_free()
	config_bar = config_bar_pack.instantiate()
	config_bar.changed.connect(_on_change_modes)
	$CanvasLayer.add_child(config_bar)
	config_bar.position = Vector2(496, 624)
	config_bar.setup(level.avalable_functions)


func _load_level(number: int) -> void:
	var _level: PackedScene =  load("res://src/scenes/levels/level_"+str(number)+".tscn")
	level = _level.instantiate()
	add_child(level)
	level.end.connect(_on_ending)
	_load_config_bar()


func _on_ending() -> void:
	_kill_current_level()
	if current_level_number == LAST_LEVEL:
		return # TODO game over
	current_level_number += 1
	_load_level.call_deferred(current_level_number)


func _on_reset_button_pressed() -> void:
	_kill_current_level()
	_load_level(current_level_number)


func _kill_current_level() -> void:
	if level == null:
		return
	level.end.disconnect(_on_ending)
	level.queue_free()


func _on_change_modes(dict: Dictionary[Tout.Mode, Tout.Mode]) -> void:
	level.change_modes(dict)
