extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isJumped = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			isJumped = true
			velocity.y = JUMP_VELOCITY
		else:
			if isJumped:
				velocity.y = JUMP_VELOCITY
				isJumped = false
				

	# Input direction: -1, 0, 1
	var direction = Input.get_axis("left", "right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif  direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			if Input.is_action_pressed("ui_down"):
				animated_sprite.play("down")
			else:
				animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func hurt():
	animated_sprite.play("hurt")
	
