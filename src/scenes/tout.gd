@tool
class_name Tout extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WIDTH: int = 32

## when a collectible is taken
signal collected(collectible: Tout)

## when a killer is touched
signal killed(player: Tout)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

enum Mode {
	MOVING,
	BLOCKING,
	KILLING,
	ENDING,
	DECORING,
	COLLECTING,
}

var mode: Mode

@export var nature: Mode = Mode.BLOCKING:
	set(new_nature):
		nature = new_nature
		if Engine.is_editor_hint():
			_set_sprite()


func _ready() -> void:
	if Engine.is_editor_hint():
		nature = nature
		return
	change_mode(nature) # TODO en fonction du level
	_set_sprite()


func _set_sprite() -> void:
	match nature:
		Mode.BLOCKING:
			$ToutAnimation.animation = "blocking"
		Mode.KILLING:
			$ToutAnimation.animation = "killing"
		Mode.ENDING: 
			$ToutAnimation.animation = "ending"
		Mode.DECORING: 
			$ToutAnimation.animation = "decoring"
		Mode.COLLECTING: 
			$ToutAnimation.animation = "collecting"
		Mode.MOVING:
			$ToutAnimation.animation = "moving"


func _physics_process(delta: float) -> void:
	if mode != Mode.MOVING or Engine.is_editor_hint():
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if move_and_slide():
		var collision_count = get_slide_collision_count()
		for i in range(collision_count):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if not collider is Tout:
				continue
			match collider.mode:
				Mode.KILLING:
					killed.emit(self) 
					queue_free() # TODO this in the signal handling
				Mode.ENDING: 
					pass # TODO win
				Mode.COLLECTING:
					collected.emit(collider)
					collider.queue_free() # TODO remove in the signal handling +1 -> dans le noeu level !
				Mode.BLOCKING, Mode.MOVING, Mode.DECORING: pass


func change_mode(new_mode: Mode) -> void:
	#var previous_mode = mode
	mode = new_mode
	
	disable_mode = CollisionObject2D.DISABLE_MODE_MAKE_STATIC
	process_mode = Node.PROCESS_MODE_INHERIT
	
	match mode:
		Mode.BLOCKING:
			process_mode = Node.PROCESS_MODE_DISABLED
		Mode.KILLING:
			process_mode = Node.PROCESS_MODE_DISABLED
		Mode.ENDING: 
			process_mode = Node.PROCESS_MODE_DISABLED
		Mode.DECORING: 
			disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
			process_mode = Node.PROCESS_MODE_DISABLED
		Mode.COLLECTING: 
			process_mode = Node.PROCESS_MODE_DISABLED
			# TODO besoin d'un area
		Mode.MOVING: pass
