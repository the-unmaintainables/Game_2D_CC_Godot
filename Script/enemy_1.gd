extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var hp = 1

func _physics_process(delta: float) -> void:
	# 重力処理
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

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
