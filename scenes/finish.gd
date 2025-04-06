extends Area2D

@onready var player: CharacterBody2D = %CharacterBody2D
@export var queue = false
@export var scene_to_load: String = "res://lvl2.tscn"  # Set to the desired scene

func _process(delta: float) -> void:
	if queue:
		await get_tree().create_timer(1).timeout
		queue = false
		get_tree().change_scene_to_file(scene_to_load)

func _on_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(scene_to_load)
