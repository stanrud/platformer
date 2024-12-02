extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var heart_container = $"../CanvasLayer/HealthUI/HBoxContainer"  # Path to the HBoxContainer in the UI

@onready var full_heart_texture = preload("res://assets/sprites/full_heart.png")
@onready var empty_heart_texture = preload("res://assets/sprites/empty_heart.png")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isJumped = false
var health = 3
var invincible = false
const INVINCIBILITY_DURATION = 1.0

enum PlayerState { NORMAL, HURT, DEAD }
var state = PlayerState.NORMAL  # Default state

func _ready():
	update_health_ui()

func _physics_process(delta):
	#if state == PlayerState.DEAD:
		#animated_sprite.play("dead")
		#return  # Skip further processing when dead

	#if state == PlayerState.HURT:
		#animated_sprite.play("hurt")
		#return  # Skip further processing while hurt

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
	
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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

	move_and_slide()

func reduce_health(amount):
	if not invincible:
		health -= amount
		print("Health:", health)
		if health <= 0:
			die()
		else:
			become_invincible()
	update_health_ui()

func die():
	state = PlayerState.DEAD
	print("Player died!")
	animated_sprite.play("dead")
	queue_free() # Remove the player from the game
	Engine.time_scale = 1.0
	get_tree().paused = true  # Pause the game	
	get_tree().reload_current_scene()

func become_invincible():
	state = PlayerState.HURT
	invincible = true
	var blink_timer = 0.0
	# Blink effect during invincibility
	while blink_timer < INVINCIBILITY_DURATION:
		animated_sprite.visible = !animated_sprite.visible
		await get_tree().create_timer(0.1).timeout  # Blink every 0.1 seconds
		blink_timer += 0.1
	animated_sprite.visible = true
	invincible = false
	state = PlayerState.NORMAL

func update_health_ui():
	for i in range(heart_container.get_child_count()):
		var heart = heart_container.get_child(i) as TextureRect
		if i < health:
			heart.texture = full_heart_texture  # Set heart to full
		else:
			heart.texture = empty_heart_texture  # Set heart to empty
