extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hide()
	pass

# 何かに触れたら
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	# ダメージを受けるものなら
	if body.has_method("damage"):
		print("Groundダメージ")
		body.damage(100, true)

	pass # Replace with function body.
