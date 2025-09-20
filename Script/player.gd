extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var hp = 3
@export var bullet_scene: PackedScene

func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("player_miss", self._on_player_miss)
	signal_manager.connect("player_timeout", self._on_player_timeout)
	

func _on_player_miss():
	print("Play miss")

func _on_player_timeout():
	print("Player timeout")

func _physics_process(delta: float) -> void:
	# 重力
	if not is_on_floor():
		velocity += get_gravity() * delta

	# ジャンプ処理
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 左右移動の処理
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		# プレイヤーの向きを決める
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# 発射ボタンが押されたら弾を発射する
	if Input.is_action_just_pressed("attack"):
		hp += 1
		SignalManager.update_chage.emit(hp)
		fire_bullet()


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
	
	# 現在のシーンに弾を追加
	get_tree().root.add_child(bullet_instance)
	
# ダメージを受ける。死亡処理も記述
func damage(amount):
	hp -= amount
	print("Current HP: ", hp)
	if hp <= 0:
		SignalManager.player_miss.emit()
		queue_free()

# プレイヤーの当たり判定に当たる
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Enemy1":
		damage(1)
	pass # Replace with function body.
