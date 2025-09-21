extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# テキストの初期化
	_update_score()
	_on_timer_timeout()
	
	# update_scoreが発信されたら
	var signal_manager = get_node("/root/SignalManager")
	signal_manager.connect("update_score", self._update_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _update_score():
	$ScoreLabel.text = "Score:%06d" % GameManager.stage_score

# タイムを更新する関数
func _on_timer_timeout() -> void:
	var now_time = self.get_parent().get_node("StageTimer").time_left
	$TimeLabel.text = "Time:%03d" % int(now_time)
	pass # Replace with function body.
