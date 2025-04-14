extends Node2D
class_name StaminaIndicator

@export var radius: float = 16
@export var active_color: Color = Color(0.2, 0.8, 1.0)
@export var background_color: Color = Color(0.1, 0.1, 0.3, 0.5)
@export var line_width: float = 4.0
@export var border_color: Color = Color(0, 0, 0)
@export var border_width: float = 1.0

var stamina_amount := 1.0:
	set(value):
		stamina_amount = clamp(value, 0.0, 1.0)
		queue_redraw()

func _draw():
	# Outer border
	draw_circle(Vector2.ZERO, radius + border_width, border_color)
	
	# Background circle
	draw_circle(Vector2.ZERO, radius, background_color)
	
	# Inner border
	draw_circle(Vector2.ZERO, radius - border_width, border_color)
	
	# Active stamina arc
	draw_arc(
		Vector2.ZERO,
		radius - border_width,  # Draw inside inner border
		-PI/2,
		-PI/2 + (TAU * stamina_amount),
		32,
		active_color,
		line_width,
		true
	)

func update_arc(ratio: float):
	stamina_amount = ratio
