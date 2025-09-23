extends Path2D

@export var EnemyScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 敵のインスタンスを作成
	var enemy_instance = EnemyScene.instantiate()
	# 敵の位置を設定
	enemy_instance.global_position = position
	
	# PathFollowに追加
	self.get_node("PathFollow2D").add_child(enemy_instance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
