extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	SignalManager.stage_start.emit()
	GameManager.load_stage1_scene()
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	GameManager.load_title_scene()
	pass # Replace with function body.
