extends Area2D

@onready var player: CharacterBody2D = %CharacterBody2D  # This works *if the player is a child or nearby node*

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player.goDOWN = true

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player.goDOWN = false
