class_name Level extends Node

var touts: 
	get(): return $Touts.get_children()

var collected: int = 0

signal end

func _ready() -> void:
	for tout: Tout in touts:
		tout.collected.connect(_on_collected)
		tout.killed.connect(_on_killed)
		tout.end.connect(_on_ending)


func _on_collected(collectible: Tout) -> void:
	collectible.queue_free()
	collected += 1


func _on_killed(player: Tout) -> void:
	player.queue_free()
	# TODO -> si plus qu'on seul, c'est cia !


func _on_ending(_player: Tout) -> void:
	end.emit()


func change_modes(dict: Dictionary[Tout.Mode, Tout.Mode]) -> void:
	for tout: Tout in touts:
		tout.change_mode(dict[tout.nature])
