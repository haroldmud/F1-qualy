extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.volume_db = -10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.won:
		$CenterContainer/Label.text = "GAME WON 🥳"
		$CenterContainer/TimeMargin/Label.text = "Time: " + Global.time
		$CenterContainer/ScoreMargin/Label.text = "Score: " + str(Global.score)
	elif not Global.won:
		$CenterContainer/Label.text = "GAME LOST 😔 "
		$CenterContainer/ScoreMargin/Label.text = "Score: " + str(Global.score)
		
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
