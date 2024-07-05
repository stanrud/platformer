extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_right = $AnimatedSprite2D/RayCastRight
@onready var ray_cast_left = $AnimatedSprite2D/RayCastLeft

var direction = 1
const SPEED = 60

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * SPEED * delta
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
