@tool
class_name Tout extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const WIDTH: int = 32

## when a collectible is taken
signal collected(collectible: Tout)

## when a killing is touched
signal killed(player: Tout)

## when a winning is touched
signal end(player: Tout, touched: Tout)

@onready var collision_shape: CollisionShape2D = $collision

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
	change_mode(nature)
	_set_sprite()


func _set_sprite() -> void:
	if %ToutAnimation == null:
		return
	match nature:
		Mode.BLOCKING: %ToutAnimation.animation = "blocking"
		Mode.KILLING: %ToutAnimation.animation = "killing"
		Mode.ENDING: %ToutAnimation.animation = "ending"
		Mode.DECORING: %ToutAnimation.animation = "decoring"
		Mode.COLLECTING: %ToutAnimation.animation = "collecting"
		Mode.MOVING: %ToutAnimation.animation = "moving"


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
				Mode.ENDING:
					end.emit(self, collider)
				Mode.COLLECTING:
					collected.emit(collider)
				Mode.BLOCKING, Mode.MOVING, Mode.DECORING: pass


func change_mode(new_mode: Mode) -> void:
	mode = new_mode
	
	disable_mode = CollisionObject2D.DISABLE_MODE_MAKE_STATIC
	process_mode = Node.PROCESS_MODE_INHERIT
	collision_shape.shape.size = Vector2(31, 31)
	
	match mode:
		Mode.BLOCKING, Mode.COLLECTING, Mode.ENDING: 
			process_mode = Node.PROCESS_MODE_DISABLED
		Mode.KILLING:
			process_mode = Node.PROCESS_MODE_DISABLED
			collision_shape.shape = RectangleShape2D.new() 
			collision_shape.shape.size = Vector2(28, 28)
		Mode.DECORING:
			disable_mode = CollisionObject2D.DISABLE_MODE_REMOVE
			process_mode = Node.PROCESS_MODE_DISABLED
		Mode.MOVING:
			process_mode = Node.PROCESS_MODE_INHERIT
