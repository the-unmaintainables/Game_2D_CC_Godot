extends PathFollow2D

@export var speed = 100
var reverse_direction = false
var Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reverse_direction = false
	await get_tree().create_timer(0.1).timeout
	Enemy = get_children()[0].get_node("AnimatedSprite2D")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var path_length = get_parent().curve.get_baked_length()
	var next_ratio = progress_ratio
	# オフセットを更新してパスに沿って移動
	if reverse_direction:
		next_ratio -= (speed * delta) / path_length
		#Enemy.flip_h = true
	else:
		next_ratio += (speed * delta) / path_length
		#Enemy.flip_h = false
		
	# 端についた場合
	if next_ratio >= 1.0:
		progress_ratio = 1.0
		reverse_direction = true
	elif next_ratio <= 0.0:
		progress_ratio = 0.0
		reverse_direction = false
	else:
		progress_ratio = next_ratio
