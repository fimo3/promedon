extends Area2D

@export var health := 3
@onready var sprite := $Sprite2D
@onready var collision := $CollisionShape2D
@onready var break_sound := $BreakSound
@onready var particles := $BreakParticles

func _ready():
	# Connect the area entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and body.is_dashing:
		take_damage(1)

func take_damage(amount: int):
	health -= amount
	
	# Visual feedback
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	
	if health <= 0:
		break_wall()

func break_wall():
	break_sound.play()
	particles.emitting = true
	sprite.visible = false
	collision.set_deferred("disabled", true)
	
	# Remove after particles finish
	await get_tree().create_timer(particles.lifetime)
	queue_free()
