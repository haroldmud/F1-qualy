extends CharacterBody2D

var knockback_velocity: Vector2 = Vector2.ZERO
var rotation_target: float = 0.0
var correcting_rotation := false

const KNOCKBACK_DAMPING = 1500.0
const ROTATION_CORRECT_SPEED = 6.0

const MAX_SPEED = 300.0
const ACCELERATION = 600.0
const BRAKE_FORCE = 1200.0
const FRICTION = 500.0
const ROTATION_SPEED = 2.5

var current_speed = 0.0
var start_forward : Vector2

var input_disabled := false
var coins_collected := 0 

var reversing := false
const REVERSE_SPEED = -200.0  # backward speed
const REVERSE_DURATION = 1.0  # seconds

func apply_reverse_after_collision():
	reversing = true
	current_speed = REVERSE_SPEED
	# Stop reversing automatically after duration
	_start_reverse_timer()

func _start_reverse_timer() -> void:
	var timer = get_tree().create_timer(REVERSE_DURATION)
	await timer.timeout
	reversing = false
	current_speed = 0

func disable_input(seconds: float) -> void:
	input_disabled = true
	await get_tree().create_timer(seconds).timeout
	input_disabled = false 

func _ready() -> void:
	start_forward = Vector2.RIGHT.rotated(rotation)

func _physics_process(delta: float) -> void:
	if input_disabled:
		current_speed = move_toward(current_speed, 80, FRICTION * 100 * delta)
		velocity = Vector2.RIGHT.rotated(rotation) * current_speed
		move_and_slide()
		return
	print(coins_collected)
	
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
			var movement_dir = velocity.normalized()

	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction * current_speed
	print("fasdasdfa ",coins_collected)
	
	move_and_slide()
	
func set_coins(coins :=1):
	coins_collected += coins
	
