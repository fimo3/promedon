extends Area2D

@onready var player: CharacterBody2D = %CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	player.goUP = true
func _on_body_exited(body: Node2D) -> void:
	player.goUP = false
