extends Node2D

var is_collided := false
var lap := 0
var time_elapsed := 0.0
var health := 5

func _ready() -> void:
	time_elapsed = 0.0
	$Sondtrack.play()
	$Sondtrack.volume_db = -10
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
	$UI/LapsMargin/HBoxContainer/Label.text = str(lap) + "/2"
	if lap > 2:
		Global.won = true
		get_tree().change_scene_to_file("res://game_finish.tscn")
		lap = 2

func _on_circuit_body_entered(body: Node2D) -> void:
	is_collided = true
	health -= 1
	$CrashAudio.play()
	if body is CharacterBody2D:
		var push_back = -body.velocity.normalized() * 80
		body.position += push_back
		body.velocity = Vector2.ZERO
	
	if health >= 0:
		get_tree().call_group("ui", "set_health", health)
	elif health < 0:
		Global.score = get_tree().current_scene.get_node("Player").coins_collected * 10
		get_tree().change_scene_to_file("res://game_finish.tscn")
	
	if body.has_method("disable_input"):
		body.disable_input(1.5)
		if body.rotation_degrees > -90 and body.rotation_degrees < 0 :
			body.rotation_degrees -= 30
		elif body.rotation_degrees < 90  and body.rotation_degrees > 0:
			body.rotation_degrees +=30
		elif body.rotation_degrees < -90:
			body.rotation_degrees +=30
		elif body.rotation_degrees > 90:
			body.rotation_degrees -= 30
		
func _on_recovery_timer_timeout() -> void:
	is_collided = false

func _on_coin_instance_coin_collision(somesome) -> void:
	pass

func _on_finish_line_area_body_exited(body: Node2D) -> void:
	#if body.velocity.x < 0:
		lap += 1
	#elif body.velocity.x > 0:
		#lap -= 1
