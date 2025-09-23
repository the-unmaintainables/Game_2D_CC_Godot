extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var hp = 1
@export var bullet_scene: PackedScene

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

# 弾を打つ処理
func fire_bullet():
	if bullet_scene == null:
		print("エラー: 弾のシーン")
		return
	
	# 弾のインスタンスを作成
	var bullet_instance = bullet_scene.instantiate()
	# 弾の位置を設定
	bullet_instance.global_position = position
	# 弾の向きを設定
	if $AnimatedSprite2D.flip_h:
		bullet_instance.rotation = deg_to_rad(180)
	
	bullet_instance.position.y -= 15 * 4
	
	# 現在のシーンに弾を追加
	self.get_parent().add_child(bullet_instance)

# 弾のクールタイムが終わったことを示すタイマー
func _on_bullet_timer_timeout() -> void:
	fire_bullet()
