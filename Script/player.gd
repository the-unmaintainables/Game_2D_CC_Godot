extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var hp = 3

func _ready() -> void:
	var signal_manager = get_node("/root/SignalManager")
	
	signal_manager.connect("player_miss", self._on_player_miss)

func _on_player_miss():
	print("Play miss")

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
