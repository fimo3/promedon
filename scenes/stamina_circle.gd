extends Node2D

class_name StaminaCircle

@export var radius: float = 16
@export var active_color: Color = Color(0.2, 0.8, 1.0)
@export var background_color: Color = Color(0.1, 0.1, 0.3, 0.5)
@export var line_width: float = 4.0
@export var low_stamina_threshold: float = 0.3
@export var low_stamina_color: Color = Color(1.0, 0.4, 0.4)

var stamina_amount := 1.0:
	set(value):
		stamina_amount = clamp(value, 0.0, 1.0)
		queue_redraw()

func _draw():
	# Draw background circle
	draw_circle(Vector2.ZERO, radius, background_color)
	
	# Choose color based on stamina level
	var draw_color = low_stamina_color if stamina_amount < low_stamina_threshold else active_color
	
	# Draw stamina arc (starts at top and goes clockwise)
	draw_arc(Vector2.ZERO, radius, -PI/2, -PI/2 + (TAU * stamina_amount), 
			max(8, int(32 * stamina_amount)),  # Fewer segments when low
			draw_color, line_width, true)

func update_arc(ratio: float):
	stamina_amount = ratio
func _process(delta):
	if stamina_amount < low_stamina_threshold:
		var pulse = 1.0 + sin(Time.get_ticks_msec() * 0.005) * 0.2
		scale = Vector2(pulse, pulse)
	else:
		scale = Vector2.ONE
