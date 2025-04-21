extends Area2D

@export var health := 3

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var break_sound = $BreakSound
@onready var particles = $BreakParticles

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func take_damage(amount: int):
	health -= amount
	await get_tree().create_timer(0.1).timeout	
	if health <= 0:
		break_wall()

func break_wall():
	break_sound.play()
	particles.emitting = true
	sprite.visible = false
	collision.set_deferred("disabled", true)
	
	await get_tree().create_timer(particles.lifetime)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		take_damage(1)
