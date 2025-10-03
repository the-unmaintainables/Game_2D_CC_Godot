extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect/TimeLabel.text = str(GameManager.stage_time)
	$TextureRect/ScoreLabel.text = str(GameManager.stage_score)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const AddValue_SCENE = preload("res://ui/AddValueUI.tscn")
func _on_title_button_pressed() -> void:
	#GameManager.load_title_scene()
	get_tree().change_scene_to_packed(AddValue_SCENE)
