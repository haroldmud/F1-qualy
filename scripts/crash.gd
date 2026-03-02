extends Area2D

var car_crahed := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if car_crahed:
		Global.is_crash = car_crahed
	print("car crashing: ", Global.is_crash)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity = Vector2.ZERO
	if not car_crahed:
		$MajorCrashTimer.start()
		car_crahed = true
		Global.score = 0

func _on_major_crash_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://game_finish.tscn")
	car_crahed = true
	Global.score = 0
