extends CharacterBody2D

var knockback_velocity: Vector2 = Vector2.ZERO
var rotation_target: float = 0.0
var correcting_rotation := false

const KNOCKBACK_DAMPING = 1500.0
const ROTATION_CORRECT_SPEED = 6.0

var MAX_SPEED = 300.0
const ACCELERATION = 600.0
const BRAKE_FORCE = 1200.0
const FRICTION = 500.0
const ROTATION_SPEED = 2.5

var current_speed = 0.0
var start_forward : Vector2

var input_disabled := false
var coins_collected := 0 

var reversing := false
const REVERSE_SPEED = -200.0
const REVERSE_DURATION = 1.0

var engine_playing := false
var target_volume := -40.0  # Target volume in dB
const VOLUME_FADE_SPEED = 20.0  # How fast volume changes
const MIN_VOLUME = -40.0  # Idle volume (dB)
const MAX_VOLUME = -20.0  # Full throttle volume (dB)

func apply_reverse_after_collision():
	reversing = true
	current_speed = REVERSE_SPEED
	_start_reverse_timer()

func _start_reverse_timer() -> void:
	var timer = get_tree().create_timer(REVERSE_DURATION)
	await timer.timeout
	reversing = false
	current_speed = 0

func disable_input(seconds: float) -> void:
	input_disabled = true
	input_disabled = false 

func _ready() -> void:
	start_forward = Vector2.RIGHT.rotated(rotation)
	print("Testing audio...")
	$AudioStreamPlayer2D.volume_db = 0.0  # Full volume
	$AudioStreamPlayer2D.play()
	print("Playing: ", $AudioStreamPlayer2D.playing)
	
	await get_tree().create_timer(2.0).timeout
	print("Still playing: ", $AudioStreamPlayer2D.playing)

func _physics_process(delta: float) -> void:
	
	if input_disabled:
		current_speed = move_toward(current_speed, 80, FRICTION * 100 * delta)
		velocity = Vector2.RIGHT.rotated(rotation) * current_speed
		move_and_slide()
		return
	
	# Handle engine sound volume
	if Input.is_action_pressed("forward"):
		current_speed += ACCELERATION * delta
		# Increase volume when accelerating
		target_volume = MAX_VOLUME
		
	elif Input.is_action_pressed("brake"):
		current_speed -= BRAKE_FORCE * delta
		# Lower volume when braking
		target_volume = MIN_VOLUME + 10.0  # Slightly higher than idle
		
	else:
		current_speed = move_toward(current_speed, 0, FRICTION * delta)
		# Idle volume when coasting
		target_volume = MIN_VOLUME
	
	# Smoothly fade volume
	$AudioStreamPlayer2D.volume_db = move_toward(
		$AudioStreamPlayer2D.volume_db,
		target_volume,
		VOLUME_FADE_SPEED * delta
	)
	
	# Optional: Adjust pitch based on speed for realism
	var speed_ratio = abs(current_speed) / MAX_SPEED
	$AudioStreamPlayer2D.pitch_scale = lerp(0.8, 1.2, speed_ratio)
	
	MAX_SPEED = 300 + (coins_collected * 10) 
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
	
func set_coins(coins := 1):
	coins_collected += coins
	
