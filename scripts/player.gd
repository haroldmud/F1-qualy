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

var coins_collected := 0 


var engine_playing := false
var car_is_backward := false
var target_volume := -40.0 
const VOLUME_FADE_SPEED = 20.0
const MIN_VOLUME = -40.0 
const MAX_VOLUME = -20.0

var collision_time_started = false

func _ready() -> void:
	start_forward = Vector2.RIGHT.rotated(rotation)
	$AudioStreamPlayer2D.volume_db = 0.0
	$AudioStreamPlayer2D.play()
	Global.car_collided = false
	await get_tree().create_timer(2.0).timeout

func _physics_process(delta: float) -> void:
	if Global.car_collided:
		# Only start timer once
		if not collision_time_started:
			$CollisionTimer.start()
			collision_time_started = true
		if not car_is_backward:
			current_speed = move_toward(current_speed, -150, FRICTION * delta)
			target_volume = MIN_VOLUME
		elif car_is_backward:
			current_speed = move_toward(current_speed, 150, FRICTION * delta)
			target_volume = MIN_VOLUME
		else:
			current_speed = move_toward(current_speed, -150, FRICTION * delta)
			target_volume = MIN_VOLUME
	
	elif Input.is_action_pressed("brake"):
		current_speed -= BRAKE_FORCE * delta
		car_is_backward = true
		target_volume = MIN_VOLUME + 10.0  # Slightly higher than idle
	
	elif Input.is_action_pressed("forward"):
		current_speed += ACCELERATION * delta
		car_is_backward = false
		target_volume = MAX_VOLUME
	
	else:
		current_speed = move_toward(current_speed, 0, FRICTION * delta)
		target_volume = MIN_VOLUME

	# Smoothly fade volume
	$AudioStreamPlayer2D.volume_db = move_toward(
		$AudioStreamPlayer2D.volume_db,
		target_volume,
		VOLUME_FADE_SPEED * delta
	)

	var speed_ratio = abs(current_speed) / MAX_SPEED
	$AudioStreamPlayer2D.pitch_scale = lerp(0.8, 1.2, speed_ratio)

	MAX_SPEED = 300 + (coins_collected * 10) 
	current_speed = clamp(current_speed, -MAX_SPEED, MAX_SPEED)

	# Steering only if moving
	if current_speed > 5:
		if Input.is_action_pressed("left"):
			rotation -= ROTATION_SPEED * delta
		if Input.is_action_pressed("right"):
			rotation += ROTATION_SPEED * delta
	elif current_speed < 0:
		if Input.is_action_pressed("left"):
			rotation += ROTATION_SPEED * delta 
		if Input.is_action_pressed("right"):
			rotation -= ROTATION_SPEED * delta

	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction * current_speed
	move_and_slide()

func set_coins(coins := 1):
	coins_collected += coins
	
func _on_collision_timer_timeout() -> void:
	Global.car_collided = false
	collision_time_started = false
	print("collision timer baby")
