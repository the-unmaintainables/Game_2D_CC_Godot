extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("stage_clear", self._on_player_clear)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# タイマーの残り時間を取得
	var remaining_time = int(time_left)
	#print("残り時間: " + str(remaining_time))

# ステージクリアした時のタイムを記録
func _on_player_clear():
	GameManager.stage_time = int(time_left)

# タイマーが終了した時の処理
func _on_timeout() -> void:
	SignalManager.player_timeout.emit()
	print("時間切れ")
