extends Area2D

@onready var player: CharacterBody2D = %CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	if player.jumps < 4:
		player.jumps += 1
		player.sprite.scale.x += 0.2
		player.sprite.scale.y += 0.2
		player.shape.scale.x += 0.2
		player.shape.scale.y += 0.2
		queue_free()
