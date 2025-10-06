extends Area2D

@export var speed = 250
var lifetime = 3.0 # 寿命を3秒に設定

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 3秒後に関数を呼び出すタイマー
	get_tree().create_timer(lifetime).timeout.connect(on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 弾を前方に移動させる
	position += transform.x * speed * delta

# 時間がきたら削除される
func on_timer_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# ダメージを受けるものなら
	if body.has_method("damage"):
		body.damage(1)
		queue_free()
	queue_free()
