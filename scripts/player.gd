extends CharacterBody2D

var knockback_velocity: Vector2 = Vector2.ZERO
var rotation_target: float = 0.0
var correcting_rotation := false

const KNOCKBACK_DAMPING = 1500.0
const ROTATION_CORRECT_SPEED = 6.0

const MAX_SPEED = 400.0
const ACCELERATION = 600.0
const BRAKE_FORCE = 1200.0
const FRICTION = 500.0
const ROTATION_SPEED = 2.5

var current_speed = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("forward"):
		current_speed += ACCELERATION * delta
	elif Input.is_action_pressed("brake"):
		current_speed -= BRAKE_FORCE * delta
	else:
		current_speed = move_toward(current_speed, 0, FRICTION * delta)

	current_speed = clamp(current_speed, -MAX_SPEED, MAX_SPEED)
	
	
	# Steering only if moving
	if abs(current_speed) > 5:
		if Input.is_action_pressed("left"):
			rotation -= ROTATION_SPEED * delta
		if Input.is_action_pressed("right"):
			rotation += ROTATION_SPEED * delta

	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction * current_speed
	
	move_and_slide()
