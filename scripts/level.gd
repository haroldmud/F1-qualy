extends Node2D

var is_collided := false
var lap := 0
var time_elapsed := 0.0
var health := 5
var is_lap_two:= false
var fake_lap := 0

@onready var lap_label: Label = get_tree().current_scene.get_node("UI/LapsMargin/HBoxContainer/Label")

func _ready() -> void:
	time_elapsed = 0.0
	$Sondtrack.play()
	$Sondtrack.volume_db = -20
	get_tree().call_group("ui", "set_health", health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	Global.score = 1200/time_elapsed * get_tree().current_scene.get_node("Player").coins_collected
	var minutes = int(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	var milliseconds = int((time_elapsed - int(time_elapsed)) * 100)
	Global.time = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	
	$UI/ScoreMargin/Label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	if lap == 2 or is_lap_two:
		fake_lap = 2
	print(is_lap_two)
	$UI/LapsMargin/HBoxContainer/Label.text = str(fake_lap) + "/2"

	if lap > 2:
		Global.won = true
		get_tree().change_scene_to_file("res://game_finish.tscn")
		lap = 2
	
	print("the laps are=: ", lap)

func _on_circuit_body_entered(body: Node2D) -> void:
	is_collided = true
	health -= 1
	$CrashAudio.play()
	if body is CharacterBody2D:
		body.velocity = Vector2.ZERO
		if body.has_method("set"):
			body.current_speed = 0.0
		Global.car_collided = true
	
	if health >= 0:
		get_tree().call_group("ui", "set_health", health)
	elif health < 0:
		Global.score = get_tree().current_scene.get_node("Player").coins_collected * 10
		get_tree().change_scene_to_file("res://game_finish.tscn")
		Global.won = false
	

func _on_recovery_timer_timeout() -> void:
	is_collided = false

func _on_coin_instance_coin_collision(somesome) -> void:
	pass

func _on_finish_line_area_body_exited(body: Node2D) -> void:
		Global.first_line = true
		Global.second_line = false
		
		if lap == 0:
			fake_lap = 1
		
		if lap == 1:
			is_lap_two = true
		
		if lap == 2:
			lap = 3
			

func _on_lap_counter_body_entered(body: Node2D) -> void:
	if not Global.second_line and Global.first_line:
		Global.first_line = false
		
		lap += 1
