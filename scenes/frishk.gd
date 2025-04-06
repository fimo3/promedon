extends AnimatedSprite2D
@onready var killzone: Area2D = $"../Killzone"

@onready var frishk: AnimatedSprite2D = $"."
@onready var player: CharacterBody2D = %CharacterBody2D

@export var speed = 100.0  # Movement speed
@export var steps = 200.0  # Distance before switching direction

var _direction = -1  # -1 for left, 1 for right
var _distance_traveled = 0.0

func _process(delta: float) -> void:
	move_left_and_right(delta)

func move_left_and_right(delta: float) -> void:
	position.x += _direction * speed * delta
	_distance_traveled += speed * delta

	if _distance_traveled >= steps:
		_direction *= -1  # Reverse direction
		_distance_traveled = 0.0  # Reset distance

	# Change animation based on direction
	if _direction == -1:
		frishk.play("change_direction")  # Replace with actual animation name
	else:
		frishk.play("idle")  # Replace with actual animation name

func _on_body_entered(body: Node2D) -> void:
	killzone.queue = true
	player.isdying = true
	await get_tree().create_timer(1).timeout
	player.isdying = false
