extends Area2D

@export var coin_scene : PackedScene
@export var coin_count := 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_coins()
	
func spawn_coins() -> void:
	var polygon :PackedVector2Array = $CollisionPolygon2D.polygon
		# Get bounding rectangle of polygon
	var bounds = Rect2(polygon[0], Vector2.ZERO)
	for point in polygon:
		bounds = bounds.expand(point)
	
	var spawned := 0
	
	while spawned < coin_count:
		# Pick random point inside bounding box
		var random_point = Vector2(
			randf_range(bounds.position.x, bounds.end.x),
			randf_range(bounds.position.y, bounds.end.y)
		)
		
		# Check if inside polygon
		if Geometry2D.is_point_in_polygon(random_point, polygon):
			var coin = coin_scene.instantiate()
			coin.position = random_point + global_position
			add_child(coin)
			spawned += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
