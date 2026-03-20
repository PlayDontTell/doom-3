class_name Tout
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum Mode {
	MOVING,
	BLOCKING,
	KILLING,
	ENDING,
	DECORING,
	COLLECTING,
}

@export var mode: Mode = Mode.BLOCKING

func _physics_process(delta: float) -> void:
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

	move_and_slide()


func change_mode(new_mode: Mode) -> void:
	var previous_mode = mode
	mode = new_mode
	
	disable_mode = CollisionObject2D.DISABLE_MODE_MAKE_STATIC
	process_mode = Node.PROCESS_MODE_INHERIT
	
	match previous_mode:
		Mode.MOVING: pass
		Mode.BLOCKING: pass
		Mode.KILLING: pass
		Mode.ENDING: pass
		Mode.DECORING: pass
		Mode.COLLECTING: pass
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
			# TODO besoin d'un area
			pass
		Mode.MOVING: pass
