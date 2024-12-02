extends Node

@onready var score_label = $ScoreLabel

@onready var score_labelUI = $"../CanvasLayer/VBoxContainer/Label2"

var score = 0

func add_point():  
	score += 1
	print("+1 coin")
	score_label.text = "You collected " + str(score) + " coins!"
	score_labelUI.text = "Coins Collected: " + str(score)
