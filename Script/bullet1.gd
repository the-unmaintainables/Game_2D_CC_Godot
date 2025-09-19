extends Area2D

@export var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 弾を前方に移動させる
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	# ダメージを受けるものなら
	if body.has_method("damage"):
		body.damage(1)
		queue_free()
