extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_circuit_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var push_back = -body.velocity.normalized() * 60
		body.position += push_back
		body.velocity = Vector2.ZERO
		print(body.rotation_degrees)
		if body.rotation_degrees > -90 and body.rotation_degrees < 0 :
			body.rotation_degrees -= 30
		elif body.rotation_degrees < 90  and body.rotation_degrees > 0:
			body.rotation_degrees +=30
		elif body.rotation_degrees < -90:
			body.rotation_degrees +=30
		elif body.rotation_degrees > 90:
			body.rotation_degrees -= 30
		
