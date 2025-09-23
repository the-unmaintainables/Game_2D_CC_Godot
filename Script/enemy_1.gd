extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var hp = 1

func _physics_process(delta: float) -> void:
	# 重力処理
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	#move_and_slide()
	
	# 親ノード(PathFollow2D)から位置を受け取る
	#position = get_parent().global_position
	
	if get_parent():
		$AnimatedSprite2D.flip_h = get_parent().reverse_direction
		#print("Enemyで変数を取得")
	pass

# ダメージを受ける。死亡処理も記述
func damage(amount):
	hp -= amount
	if hp <= 0:
		GameManager.stage_score += 1000
		SignalManager.update_score.emit()
		queue_free()

# 当たり判定に触れたら
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#body.damage(1)
		pass
