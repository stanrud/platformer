extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_top = $AnimatedSprite2D/Area2D/RayCastTop
@onready var ray_cast_left = $AnimatedSprite2D/Area2D/RayCastLeft
@onready var ray_cast_right = $AnimatedSprite2D/Area2D/RayCastRight
@onready var animation_player = $AnimationPlayer

var direction = 1
const SPEED = 60
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	position.x += direction * SPEED * delta

	if ray_cast_right.is_colliding():
		var collider = ray_cast_right.get_collider()
		if (collider.get_name() == 'Player'):
			collider.reduce_health(1)  # Call the method on the player
		else:
			direction = -1
			animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if ray_cast_top.is_colliding():
		direction = 0
		animation_player.play("kill-slime")
		#queue_free()
		print('killed enemy')
