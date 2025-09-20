extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/TextureRect/TimeLabel.text = str(GameManager.stage_time)
	$CanvasLayer/TextureRect/ScoreLabel.text = str(GameManager.stage_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_button_pressed() -> void:
	GameManager.load_title_scene()
