extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PauseOverlay.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		print("pauseアクションの受け取り")
		# ポーズ状態を切り替える
		get_tree().paused = not get_tree().paused
		
		# オーバーレイの表示/非表示を切り替える
		$PauseOverlay.visible = get_tree().paused
	pass

func _on_start_button_pressed() -> void:
	# ポーズの解除
	get_tree().paused = not get_tree().paused
	
	# オーバーレイの表示の切り替え
	$PauseOverlay.visible = get_tree().paused
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	GameManager.load_title_scene()
	pass # Replace with function body.
