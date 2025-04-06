extends AnimatedSprite2D

var angry = false
var big = false
var isin = false

@onready var killzone: Area2D = $"../Killzone"
@onready var player: CharacterBody2D = %CharacterBody2D
@onready var pufferfish: AnimatedSprite2D = $"."

func _process(delta: float) -> void:
	if big:
		pufferfish.play("big")
	elif angry:
		pufferfish.play("angry")
	else:
		pufferfish.play("idle")

func _on_big_body_entered(body: Node2D) -> void:
	if body == player:
		isin = true
		if big:
			killzone.queue = true
		elif not angry and not big:
			start_transition()

func _on_big_body_exited(body: Node2D) -> void:
	if body == player:
		isin = false

func start_transition() -> void:
	angry = true
	pufferfish.play("angry")
	await get_tree().create_timer(1.5).timeout
	angry = false
	big = true
	if isin:
		killzone.queue = true
		player.isdying = true
		await get_tree().create_timer(1).timeout
		player.isdying = false
	await get_tree().create_timer(3).timeout
	big = false
	pufferfish.play("idle")


func _on_small_body_entered(body: Node2D) -> void:
	killzone.queue = true
	player.isdying = true
	await get_tree().create_timer(1).timeout
	player.isdying = false
