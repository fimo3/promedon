extends CharacterBody2D

const GRAVITY = -1000
const JUMP_FORCE = 500
const CEILING_DETECTION_OFFSET = 10
const VELOCITY = 300
const FAN_SPEED = 200
const DASH_SPEED = 800
const DASH_DURATION = 0.15
const DASH_COOLDOWN = 0.3
const DASH_STAMINA_COST = 15
const STAMINA_REGEN_RATE = 25.0
const STAMINA_REGEN_DELAY = 0.5

var player_scale = 1.0
var double_jump = true
var jumps = 4
var isdying = false
var can_dash = true
var is_dashing = false
var size = 1.0
var dash_direction = Vector2.ZERO
var current_stamina = 100
var max_stamina = 100
var stamina_regen_timer = 0.0
var was_in_air = false

@export var goUP = false
@export var goDOWN = false
@export var goLEFT = false
@export var goRIGHT = false

@onready var sprite = $AnimatedSprite2D
@onready var shape = $CollisionShape2D
@onready var stamina_indicator = $StaminaIndicator

func _ready():
	stamina_indicator.radius = 16
	stamina_indicator.position = Vector2(0, -50)
	update_stamina_display()

func _physics_process(delta):
	if isdying:
		velocity.y = 0
		velocity.x = 0
		sprite.play("death")
		return
	
	if stamina_regen_timer > 0:
		stamina_regen_timer -= delta
	elif current_stamina < max_stamina:
		current_stamina = min(max_stamina, current_stamina + STAMINA_REGEN_RATE * delta)
		update_stamina_display()
	
	if !is_dashing:
		velocity.y += GRAVITY * delta
		
		if goUP:
			velocity.y += -FAN_SPEED / 10
		
		if goDOWN:
			velocity.y += FAN_SPEED / 10
		
		if goRIGHT:
			velocity.x = 2 * FAN_SPEED
		
		if goLEFT:
			velocity.x = 2 * -FAN_SPEED
			
		if !goLEFT && !goRIGHT:
			if velocity.x > 0:
				velocity.x -= 10
			elif velocity.x < 0:
				velocity.x += 10

		if is_on_ceiling() && !goDOWN:
			velocity.y = 0
		
		handle_movement_input()
		
		if Input.is_action_just_pressed("dash") and can_dash and current_stamina >= DASH_STAMINA_COST:
			start_dash()
	else:
		velocity = dash_direction * DASH_SPEED
	
	move_and_slide()
	
	if is_dashing and (is_on_wall() or is_on_ceiling() or is_on_floor()):
		end_dash()
	
	# Landing detection
	if !is_on_ceiling() and !is_dashing:
		was_in_air = true
	elif was_in_air and is_on_ceiling():
		on_land()
		was_in_air = false

func update_stamina_display():
	stamina_indicator.update_arc(float(current_stamina) / max_stamina)

func handle_movement_input():
	if Input.is_action_just_pressed("jump") and is_on_ceiling() and jumps > 0:
		start_jump()
	
	if Input.is_action_pressed("move_left"):
		if goLEFT && !goRIGHT:
			velocity.x = -VELOCITY-1.5 * FAN_SPEED
		elif !goLEFT && goRIGHT:
			velocity.x = -VELOCITY+FAN_SPEED
		else:
			velocity.x = -VELOCITY
	
	if Input.is_action_just_released("move_left"):
		if goLEFT && !goRIGHT:
			velocity.x = 2 * -FAN_SPEED
		elif !goLEFT && goRIGHT:
			velocity.x = 2 * FAN_SPEED
		else:
			velocity.x = 0
	
	if Input.is_action_pressed("move_right"):
		if goLEFT && !goRIGHT:
			velocity.x = VELOCITY-FAN_SPEED
		elif !goLEFT && goRIGHT:
			velocity.x = VELOCITY+1.5 * FAN_SPEED
		else:
			velocity.x = VELOCITY
	
	if Input.is_action_just_released("move_right"):
		if goLEFT && !goRIGHT:
			velocity.x = 2 * -FAN_SPEED
		elif !goLEFT && goRIGHT:
			velocity.x = 2 * FAN_SPEED
		else:
			velocity.x = 0
			
	if Input.is_action_just_pressed("jump") and !is_on_ceiling() and double_jump and jumps > 0:
		double_jump = false
		velocity.y += 500
		size-=0.2
		update_scale(-0.2)
		jumps -= 1
	
	if sprite: sprite.play("default")

func start_jump():
	sprite.play("jump_start")
	velocity.y = JUMP_FORCE
	update_scale(-0.2)
	size-=0.2
	jumps -= 1
	double_jump = true

func on_land():
	var current_scale = sprite.scale.x
	sprite.play("jump_end")
func start_dash():
	dash_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		dash_direction.x = -1
	elif Input.is_action_pressed("move_right"):
		dash_direction.x = 1
	
	if dash_direction == Vector2.ZERO:
		dash_direction.x = 1
	
	dash_direction = dash_direction.normalized()
	
	is_dashing = true
	can_dash = false
	current_stamina -= DASH_STAMINA_COST
	stamina_regen_timer = STAMINA_REGEN_DELAY
	
	sprite.play("dash")
	size = sprite.scale.x
	sprite.scale.x *= 1.2
	sprite.scale.y *= 0.8
	
	await get_tree().create_timer(DASH_DURATION).timeout
	end_dash()
	
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true

func end_dash():
	is_dashing = false
	velocity = Vector2.ZERO
	sprite.scale.x = size
	sprite.scale.y = size

func update_scale(amount: float):
	sprite.scale.x += amount
	sprite.scale.y += amount
	shape.scale.x += amount
	shape.scale.y += amount

func _on_finish_body_entered(body: Node2D) -> void:
	pass
