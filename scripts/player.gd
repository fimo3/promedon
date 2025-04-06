extends CharacterBody2D

const GRAVITY = -1000
const JUMP_FORCE = 500
const CEILING_DETECTION_OFFSET = 10
const VELOCITY = 300
const FAN_SPEED = 200

var double_jump = true

@export var jumps = 4
@export var isdying = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shape: CollisionShape2D = $CollisionShape2D

@export var goUP = false
@export var goDOWN = false
@export var goLEFT = false
@export var goRIGHT = false

func _physics_process(delta):
	
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
	
	if Input.is_action_just_pressed("jump") and is_on_ceiling() and jumps > 0:
		velocity.y = JUMP_FORCE
		sprite.scale.x -= 0.2
		sprite.scale.y -= 0.2
		shape.scale.x -= 0.2
		shape.scale.y -= 0.2
		jumps -= 1
		double_jump = true
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
		sprite.scale.x -= 0.2
		sprite.scale.y -= 0.2
		shape.scale.x -= 0.2
		shape.scale.y -= 0.2
		jumps -= 1
	if isdying:
		velocity.y = 0
		velocity.x = 0
		sprite.play("death")
	else:
		sprite.play("default")
	move_and_slide()


func _on_finish_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
