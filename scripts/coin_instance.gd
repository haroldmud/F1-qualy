extends Area2D

var player_node : Node2D
var collect := 1

func _ready():
	player_node = get_tree().current_scene.get_node("Player")
	# Connect the signal when the coin is ready
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	#print(player_node.coins_collected)
	pass

func _on_body_entered(body: Node2D) -> void:
	if body != player_node:
		return
	
	# Increment the player's coin count
	player_node.coins_collected += 1
	
	$Coin.visible = false
	$CoinCollisionShape.set_deferred("disabled", true)
