extends Node2D

@export var speed: float = 100.0 
@export var start_x: float = -1300.0
@export var end_x: float = 3100.0

func _process(delta: float) -> void:
	position.x += speed * delta

	if position.x > end_x:
		position.x = start_x
