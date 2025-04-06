extends Area2D

@onready var player: CharacterBody2D = %CharacterBody2D
@export var queue = false

func _process(delta: float) -> void:
	if queue:
		await get_tree().create_timer(1).timeout
		queue = false
		get_tree().reload_current_scene()

func _on_body_entered(body: Node2D) -> void:
	player.isdying = true
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
	player.isdying = false
