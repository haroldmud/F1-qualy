extends Area2D

var player_node : Node2D
var collect := 1
signal coin_collision


func _ready():
	# Assign the player node (or game manager)
	player_node =get_tree().current_scene.get_node("Player")
	
func _process(delta: float) -> void:
	print(player_node.coins_collected)

func _on_body_entered(body: Node2D) -> void:
	coin_collision.emit()
	get_tree().call_group("coins", "set_coins", 1)
	if body != player_node:
		return
	$Coin.visible = false
	if $CollisionShape2D:
		$CollisionShape2D.set_deferred("disabled", true)
