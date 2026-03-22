class_name Level extends Node

@export var avalable_functions: Array[Tout.Mode] = [
	Tout.Mode.MOVING,
	Tout.Mode.BLOCKING,
	Tout.Mode.KILLING,
	Tout.Mode.ENDING,
	Tout.Mode.DECORING,
	Tout.Mode.COLLECTING,
]
@export var allowed_nature_to_win: Array[Tout.Mode] = [
	Tout.Mode.MOVING,
]
@export var show_tuto = false

const tout_pack = preload("res://src/scenes/tout.tscn")

var touts: 
	get(): return $Touts.get_children()

var _collected: int = 0

signal end
signal collected

func _ready() -> void:
	for tout: Tout in touts:
		tout.collected.connect(_on_collected)
		tout.killed.connect(_on_killed)
		tout.end.connect(_on_ending)


func _on_collected(collectible: Tout) -> void:
	collectible.queue_free()
	_collected += 1
	collected.emit()


func _on_killed(player: Tout) -> void:
	player.queue_free()
	# TODO -> si plus qu'on seul, c'est cia !


func _on_ending(player: Tout, touched: Tout) -> void:
	var is_proper_ending = touched.nature == Tout.Mode.ENDING and touched.mode == Tout.Mode.ENDING
	if is_proper_ending and player.nature in allowed_nature_to_win:
		end.emit()
	else:
		# TODO animation "on ne peut pas gagner avec ca"
		pass


func change_modes(dict: Dictionary[Tout.Mode, Tout.Mode]) -> void:
	var to_ungroup = []
	var to_group = []
	for tout: Tout in touts:
		if tout.mode == Tout.Mode.MOVING and dict[tout.nature] != Tout.Mode.MOVING:
			to_ungroup.push_back(tout)
		if tout.mode != Tout.Mode.MOVING and dict[tout.nature] == Tout.Mode.MOVING:
			to_group.push_back(tout)
		tout.change_mode(dict[tout.nature])
	
	if not to_group.is_empty():
		var group = to_group.pop_back()
		for a: Tout in to_group:
			a.get_child(0).reparent(group)
			a.queue_free()
	
	if not to_ungroup.is_empty():
		for toto: Tout in to_ungroup:
			if toto.get_children().size() <= 1:
				continue
			for b: CollisionShape2D in toto.get_children():
				var new_tout: Tout = tout_pack.instantiate()
				new_tout.nature = toto.nature
				new_tout.mode = toto.mode # TODO pas sur
				$Touts.add_child(new_tout)
				new_tout.global_position = b.global_position
			toto.queue_free()
