extends Camera2D

@export var player_path: NodePath

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and is_instance_valid(player):  # Ensure the player exists
		global_position = player.global_position
