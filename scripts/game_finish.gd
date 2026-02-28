extends CanvasLayer

const SAVE_FILE = "user://best_score.save"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.volume_db = -10
	
	# Update best score if current score is higher
	var best_score = load_best_score()
	if Global.score > best_score:
		save_best_score(Global.score)
		best_score = Global.score
	
	$BestScoreMargin/Label.text = "Best Score: " + str(best_score)

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

# Save the best score to file
func save_best_score(score: int) -> void:
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(score)
		file.close()

# Load the best score from file
func load_best_score() -> int:
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var score = file.get_var()
			file.close()
			return score
	return 0  # Return 0 if no save file exists
