extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_health(health_amount):
	for child in $HealthMargin2/HBoxContainer.get_children():
		child.queue_free()
		
	for life in health_amount:
		var battery_life = TextureRect.new()
		battery_life.texture = load("res://assets/icons/rectangle.png")
		$HealthMargin2/HBoxContainer.add_child(battery_life)
