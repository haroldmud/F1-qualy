extends Node2D

var is_collided := false
var lap := 0
var time_elapsed := 0.0
var health := 5

func _ready() -> void:
	time_elapsed = 0.0
	get_tree().call_group("ui", "set_health", health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	
	var minutes = int(time_elapsed / 60)
	var seconds = int(time_elapsed) % 60
	var milliseconds = int((time_elapsed - int(time_elapsed)) * 100)
	
	$UI/ScoreMargin/Label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	$UI/LapsMargin/HBoxContainer/Label.text = str(lap) + "/2"

func _on_circuit_body_entered(body: Node2D) -> void:
	is_collided = true
	health -= 1
	if body is CharacterBody2D:
		var push_back = -body.velocity.normalized() * 80
		body.position += push_back
		body.velocity = Vector2.ZERO
	
	if health >= 0:
		get_tree().call_group("ui", "set_health", health)
	elif health < 0:
		print("Nigga, you died")
	
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
	#print(somesome) -  this is for the amount of coins collected
	pass

func _on_finish_line_area_body_exited(body: Node2D) -> void:
	#if body.velocity.x < 0:
		lap += 1
	#elif body.velocity.x > 0:
		#lap -= 1
