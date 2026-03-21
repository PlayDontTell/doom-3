class_name Game extends Node2D

var level: Level
var current_level_number: int = 1

const LAST_LEVEL = 3

func _ready() -> void:
	_load_level(current_level_number)


func _load_level(number: int) -> void:
	var _level:PackedScene =  load("res://src/scenes/levels/level_"+str(number)+".tscn")
	level = _level.instantiate()
	add_child(level)
	level.end.connect(_on_ending)


func _on_ending() -> void:
	level.queue_free()
	if current_level_number == LAST_LEVEL:
		return # TODO game over
	current_level_number += 1
	_load_level.call_deferred(current_level_number)
